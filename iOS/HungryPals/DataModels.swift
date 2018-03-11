//
//  DataModels.swift/Users/iguest/Desktop/HungryPals/iOS/HungryPals/Post.swift
//  HungryPals
//
//  Created by Leon T Long on 3/1/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import Foundation
import Alamofire

class Post {
    public var postId:String
    public var creator:User
    public var createdAt:Date
    public var status:String // WAITING, REQUESTED, CONFIRMED
    public var matchedPostId:String = ""
    public var requestedBy:User? = nil
    public var startTime:Date
    public var endTime:Date
    public var restaurant:String
    public var cuisine:String
    public var notes:String
    
    init(postId:String, creator:User, createdAt:Date, status:String, startTime:Date, endTime:Date, restaurant:String, cuisine:String, notes:String ) {
        self.postId = postId
        self.creator = creator
        self.createdAt = createdAt
        self.status = status
        self.startTime = startTime
        self.endTime = endTime
        self.restaurant = restaurant
        self.cuisine = cuisine
        self.notes = notes
    }
}

class User {
    public var username:String
    public var email:String
    public var location:String
    public var userId:String
    public var profilePic:String
    public var deviceToken:String
    public var cuisineMarked: [Bool] = [false, false, false, false, false, false, false, false, false, false]
    
    init(username:String, email:String, location:String, userId:String, profilePic:String, deviceToken:String) {
        self.username = username
        self.email = email
        self.location = location
        self.userId = userId
        self.profilePic = profilePic
        self.deviceToken = deviceToken
    }
    
    func updatePref(_ markedPrefs:[Bool]) {
        self.cuisineMarked = markedPrefs
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "H:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

import UIKit

class DataRepository {
    public var matchablePosts:[Post] = [] // others' matchable posts
    public var pendingPosts:[Post] = [] // my posts and pending requested posts
    public var confirmedPosts:[Post] = []
    public var user:User? = nil
    
    public let baseURL = "https://appcode.leontaolong.com:8449"
    //    public let baseURL = "http://localhost:8448"
    
    open let accountList: [String] = ["Cuisine Preference", "Live in ", "Terms & privacy policiy", "About Hungry Pals"]
    open let accountListIcon: [String] = ["like", "location", "policy", "about"]
    public let cuisine: [String] = ["American", "Chinese", "Korean", "Italian", "Japanese", "Mexican", "Indian", "Thai", "Vegan", "Greek"]
    
    static let shared = DataRepository()
    
    
    init() {
        httpFetchPosts()
    }
    
    /* IN-APP METHODS FOR OTHER COMPONENTS */
    func getMatchablePosts() -> [Post] {
        httpFetchPosts()
        print(matchablePosts)
        return matchablePosts
    }
    
    func createUser(username:String, email:String, location:String, userId:String, profilePic:String, deviceToken:String) {
        
        user = User(username: username, email: email, location: location, userId: userId, profilePic: profilePic, deviceToken: deviceToken)
        
        httpAddUser(username: username, email: email, location: location, userId: userId, profilePic: profilePic, deviceToken: deviceToken)
    }
    
    func getUser() -> User {
        return user!
    }
    
    func createPost(startTime:Date, endTime:Date, restaurant:String, cuisine:String, notes:String) {
        let creator = serializeUser(user!)
        
        httpAddPost(creator:creator, startTime: String(startTime.timeIntervalSince1970), endTime: String(endTime.timeIntervalSince1970), restaurant: restaurant, cuisine: cuisine, notes: notes)
    }
    
    func getMatchablePostById(_ postId:String) -> Post {
        return matchablePosts.filter({ (post) -> Bool in
            post.postId == postId
        })[0]
    }
    
    func getPendingPostById(_ postId:String) -> Post {
        return pendingPosts.filter({ (post) -> Bool in
            post.postId == postId
        })[0]
    }
    
    func requestPost(index:Int) {
        let postId = matchablePosts[index].postId
        let requestedBy = serializeUser(user!)
        let matchedPostId = getMatchablePostById(postId).matchedPostId
        httpRequestPost(index, postId, requestedBy, matchedPostId)
    }
    
    func respondPost(confirmed:Bool, postId:String) {
        httpRespondPost(confirmed, postId)
    }
    
    
    /* ENCAPSULATED INTERNAL HTTP METHODS */
    fileprivate func httpAddUser(username:String, email:String, location:String, userId:String, profilePic:String, deviceToken:String) {
        let jsonData = serializeUser(user!)
        Alamofire.request(baseURL + "/v1/user", method: .post, parameters: jsonData, encoding:JSONEncoding.default)
            .responseString {response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(String(describing: response.result.value))")
        }
    }
    
    fileprivate func httpAddPost(creator:[String:String], startTime:String, endTime:String, restaurant:String, cuisine:String, notes:String) {
        
        let jsonData: [String: Any] = [
            "creator": creator,
            "startTime": startTime,
            "endTime": endTime,
            "restaurant": restaurant,
            "cuisine": cuisine,
            "notes": notes,
            ]
        
        Alamofire.request(baseURL + "/v1/post", method: .post, parameters: jsonData, encoding:JSONEncoding.default)
            .responseJSON {response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(String(describing: response.result.value))")
                let json = response.result.value as! [String:AnyObject]
                let post = self.deserializePost(json)
                self.pendingPosts.append(post);
        }
    }
    
    
    fileprivate func httpFetchPosts() {
        Alamofire.request(baseURL + "/v1/posts", method: .get)
            .responseJSON {response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(String(describing: response.result.value))")
                let json = response.result.value as! [[String:AnyObject]]
                self.matchablePosts = []
                self.pendingPosts = []
                for post in json {
                    let post = self.deserializePost(post)
                    if post.creator.userId != self.user?.userId {
                        self.matchablePosts.append(post)
                    } else {
                        self.pendingPosts.append(post)
                    }
                }
        }
    }
    
    fileprivate func httpRequestPost(_ index:Int, _ postId:String, _ requestedBy:[String:String], _ matchedPostId:String) {
        let jsonData: [String: Any] = [
            "postId": postId,
            "requestedBy": requestedBy,
            "matchedPostId": matchedPostId,
            ]
        
        Alamofire.request(baseURL + "/v1/request", method: .post, parameters: jsonData, encoding:JSONEncoding.default)
            .responseString {response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(String(describing: response.result.value))")
                let post = self.matchablePosts[index]
                post.status = "REQUESTED"
                self.pendingPosts.append(post)
                self.httpFetchPosts()
        }
    }
    
    fileprivate func httpRespondPost(_ confirmed:Bool, _ postId:String) {
        let jsonData: [String: Any] = ["confirmed": confirmed, "postId": postId]
        
        Alamofire.request(baseURL + "/v1/respond", method: .post, parameters: jsonData, encoding:JSONEncoding.default)
            .responseString {response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(String(describing: response.result.value))")
                if (confirmed) {
                    let post = self.getPendingPostById(postId)
                    self.confirmedPosts.append(post)
                }
                self.httpFetchPosts()
        }
    }
    
    fileprivate func httpDeletePost(_ postId:String) {
        let jsonData = ["postId": postId]
        
        Alamofire.request(baseURL + "/v1/post", method: .delete, parameters: jsonData, encoding:JSONEncoding.default)
            .responseString {response in
                print("Success: \(response.result.isSuccess)")
                print("Response String: \(String(describing: response.result.value))")
                self.httpFetchPosts()
        }
    }
    
    private func serializeUser(_ user:User) -> [String:String] {
        return [
            "username": user.username,
            "email": user.email,
            "location": user.location,
            "userId": user.userId,
            "profilePic": user.profilePic,
            "deviceToken": user.deviceToken,
        ]
    }
    
    private func deserializePost(_ jsonData:[String:AnyObject]) -> Post {
        let creator = deserializeUser(jsonData["creator"] as! Dictionary<String,String>)
        let startTime = parseDate(jsonData["startTime"] as! String)
        let endTime = parseDate(jsonData["endTime"] as! String)
        let createdAt = parseDate(jsonData["createdAt"] as! String)
        
        return Post(postId:jsonData["_id"] as! String, creator:creator, createdAt:createdAt, status:jsonData["status"] as! String, startTime:startTime, endTime: endTime, restaurant:jsonData["restaurant"] as! String, cuisine:jsonData["cuisine"] as! String, notes:jsonData["notes"] as! String)
    }
    
    private func deserializeUser(_ userDate:[String:String]) -> User {
        return User(username: userDate["username"]!, email: userDate["email"]!, location: userDate["location"]!, userId: userDate["userId"]!, profilePic: userDate["profilePic"]!, deviceToken: userDate["deviceToken"]!)
    }
    
    private func parseDate(_ dateString:String) -> Date {
        guard let date = Formatter.iso8601.date(from: dateString) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        return date
    }
    
    /* TEMP TEST METHODS */
    //    func test() {
    //        let date1 = parseDate("2018-03-11T05:35:28.719Z")
    //        let date2 = parseDate("2018-03-11T07:35:28.719Z")
    //        createUser(username: "Leon", email: "longt8@uw.edu", location: "Seattle", userId: "1", profilePic: "picc", deviceToken: "0b526ca9caf17ad1af43fd3ff33a9474e9c44985d1e2780088d09bc2d0a30795")
    //
    //        createPost(startTime: date1, endTime: date2, restaurant:"Red Pepp", cuisine:"Japanese", notes:"meet at 7")
    //        httpFetchPosts()
    //        httpDeletePost("5aa4a8884516d86b88f0474b")
    //        requestPost(index: 0)
    //        respondPost(confirmed: true, postId: "5aa4b2104516d86b88f0474d")
    //    }
}

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

/*import Foundation


class Post {
    private var postId:String
    private var creator:User
    private var createdAt:Date
    private var matchingStatus:String // MATCHING, WAITING_OTHER_TO_RESPOND, COMFIRMED_BY_OTHER, REJECTED, ACCEPTED
    private var matchedPost:Post? = nil
    private var matchedUser:User? = nil
    private var startTime:Date
    private var endTime:Date
    private var restaurant:String
    private var cuisine:String
    private var notes:String
    
    init(postId:String, creator:User, createdAt:Date, matchingStatus:String, startTime:Date, endTime:Date, restaurant:String, cuisine:String, notes:String ) {
        self.postId = postId
        self.creator = creator
        self.createdAt = createdAt
        self.matchingStatus = matchingStatus
        self.startTime = startTime
        self.endTime = endTime
        self.restaurant = restaurant
        self.cuisine = cuisine
        self.notes = notes
    }
    
    func getMatchedWithPost(matchedPost:Post, matchingStatus:String) {
        self.matchedPost = matchedPost
        self.matchingStatus = matchingStatus
    }
    
    func getMatchedWithUser(matchedUser:User, matchingStatus:String) {
        self.matchedUser = matchedUser
        self.matchingStatus = matchingStatus
    }
    
    // direct invite by user
    func invite(userId:String) {
        // TODO: send invite to server
    }
    
    func updateMatchingStatus(matchingStatus:String) {
        self.matchingStatus = matchingStatus
    }

    public func getCreator() -> User {
        return self.creator
    }

    public func getRestaurant() -> String {
        return self.restaurant
    }
    
    public func getCuisine() -> String {
        return self.cuisine
    }
    
    public func getStartTime() -> Date {
        return self.startTime
    }
    
    public func getEndTime() -> Date {
        return self.endTime
    }
}

class User {
    private var username:String
    private var userId:String
    private var profilePic:String
    private var cuisinePrefs:[String] = []
    private var deviceToken:String = ""
    private var friendList:[String]
    
    init(username:String, userId:String, profilePic:String, friendList:[String], deviceToken:String, cuisinePrefs:[String]) {
        self.username = username
        self.userId = userId
        self.profilePic = profilePic
        self.friendList = friendList
        self.cuisinePrefs = cuisinePrefs
        self.deviceToken = deviceToken
    }

    public func getUsername() -> String {
        return self.username
    }
    
    public func getProfilePic() -> String {
        return self.profilePic
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "H:mm a"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        //dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

import UIKit

class PostRepository {
    private var posts = [Post]()
    private var users = [User]()
    
    static let shared = PostRepository()
    
    func initialization() {
        let userOne = User(username: "Estelle", userId: "1234ABC", profilePic: "https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/27073113_546712599021153_8141215265311775044_n.jpg?oh=6c3ab12fe2ba078a7598e26c7264f2a6&oe=5B0B66E1", friendList: ["Leon", "Jeff", "Joyce", "Christy", "Luga"], deviceToken: "123", cuisinePrefs:["Korean Cuisine", "Chinese Cuisine", "Pizza"])
        
        
        let userTwo = User(username: "Leon", userId: "123Abc", profilePic:"https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/26113760_1305233659623257_7535574390430053724_n.jpg?oh=d81ccbc153e4629f3253e5b2b6b32fce&oe=5B0DCA2B", friendList: ["Estelle", "Jeff", "Joyce", "Christy", "Luga"], deviceToken: "234", cuisinePrefs: ["Korean Cuisine", "Chinese Cuisine", "Pizza", "Thai Cuisine"])
        
        
        let userThree = User(username: "Jeff", userId: "123A", profilePic:"https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/13267756_595417983945505_8725481151794163864_n.jpg?oh=a8b1d918b8c05493e049f8cd73dcba56&oe=5B0FAFD7", friendList: ["Estelle", "Leon", "Joyce", "Christy", "Luga"], deviceToken: "345", cuisinePrefs: ["Chinese Cuisine", "Pizza", "Thai Cuisine"])
        
        
        let userFour = User(username: "Christy", userId: "123a", profilePic:"https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/12541131_219061571763296_6248007033796449313_n.jpg?oh=274920f2116737179958cc4d62a4689e&oe=5B0E43B0", friendList: ["Estelle", "Leon", "Joyce", "Jeff", "Luga"], deviceToken: "456", cuisinePrefs: ["Chinese Cuisine", "Pizza", "Thai Cuisine", "Korean Cuisine"])
        
        
        let userFive = User(username: "Joyce", userId: "123abc", profilePic:"https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/19399486_10212812938654492_7422685381260620425_n.jpg?oh=fff1d310d6981f211aa180b5ef90ca02&oe=5B4173E4", friendList: ["Estelle", "Leon", "Christy", "Jeff", "Luga"], deviceToken: "567", cuisinePrefs: ["Pizza", "pho/noodle", "Thai Cuisine", "Korean Cuisine"])
        
        
        let userSix = User(username: "Luga", userId: "123abcd", profilePic:"https://scontent.fsea1-1.fna.fbcdn.net/v/t1.0-1/p320x320/14670764_340208649653971_5611890079955935580_n.jpg?oh=b8d6d6a5fb4bb61976f96541a7b96251&oe=5B094A36", friendList: ["Estelle", "Leon", "Christy", "Jeff", "Joyce"], deviceToken: "567", cuisinePrefs: ["Salad", "pho/noodle", "Chinese Cuisine", "Korean Cuisine"])
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let startTime1 = formatter.date(from: "2018/03/03 12:30")
        let endTime1 = formatter.date(from: "2018/03/03 13:30")
        let startTime2 = formatter.date(from: "2018/03/04 13:30")
        let endTime2 = formatter.date(from: "2018/03/04 14:30")
        let startTime3 = formatter.date(from: "2018/03/04 12:30")
        let endTime3 = formatter.date(from: "2018/03/04 13:30")
        
        //post1 matched with post2
        let post1 = Post(postId:"123", creator: userOne, createdAt: startTime1!, matchingStatus: "matched", startTime: startTime1!, endTime: endTime1!, restaurant: "Chinese", cuisine: "Chinese Cuisine", notes: "")
        let post2 = Post(postId:"234", creator: userTwo, createdAt: startTime1!, matchingStatus: "matched", startTime: startTime1!, endTime: endTime1!, restaurant: "Korean", cuisine: "Chinese Cuisine", notes: "")
        
        //post3 & post 4, no matches and put them into the main screen
        let post3 = Post(postId:"345", creator: userThree, createdAt: startTime2!, matchingStatus: "no-matches", startTime: startTime2!, endTime: endTime2!, restaurant: "Thai", cuisine: "Thai Cuisine", notes: "We can eat Spring Kitchen!")
        let post4 = Post(postId:"456", creator: userFour, createdAt: startTime2!, matchingStatus: "no-matches", startTime: startTime2!, endTime: endTime2!, restaurant: "Japanese", cuisine: "Pizza", notes: "Maybe hamburger too.")
        
        //post5 posted first and there is no matches, post 6 has same content with post5, so post6 found match(which is post5), but he is waiting for post5 response right now.
        let post5 = Post(postId:"789", creator: userFive, createdAt: startTime3!, matchingStatus: "no-matches", startTime: startTime3!, endTime: endTime3!, restaurant: "American", cuisine: "pho/noodle", notes: "")
        let post6 = Post(postId:"890", creator: userSix, createdAt: startTime3!, matchingStatus: "waitingResponse", startTime: startTime3!, endTime: endTime3!, restaurant: "Anything", cuisine: "pho/noodle", notes: "")
        
        let userArray: [User] = [userOne, userTwo, userThree, userFour, userFive,userSix]
        let postArray: [Post] = [post1, post2, post3, post4, post5, post6]
        users = userArray
        posts = postArray
    }
    
    func getPosts() -> [Post] {
        initialization()
        return posts
    }
    
    func getUsers() -> [User] {
        return users
    }
    
    func getPost(id: Int) -> Post {
        return posts[id]
    }
    
    func deleteAllPosts() {
        posts = [Post]()
    }
    
    func deleteSubject(id: Int) {
        // remove from the array
    }
    /*
     func addSubject(title: String, desc: String, question: [Question]) {
     posts.append(Subject(title: title, desc: desc, question: question))
     }
     */
    func updateSubject(name: Post) {
        // send the update back to the server
    }
}*/
