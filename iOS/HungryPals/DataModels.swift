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
    
    func updatePref(_ index:Int) {
        self.cuisineMarked[index] = !self.cuisineMarked[index]
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
    public var notificationPostData:Post? = nil
    
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
    
    func addNotificationPostData(_ postData:[String:AnyObject]) {
        notificationPostData = deserializePost(postData as [String : AnyObject])
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
//        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}

