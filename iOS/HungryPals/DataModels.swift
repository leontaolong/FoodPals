//
//  DataModels.swift
//  HungryPals
//
//  Created by Ranhao Xu on 3/4/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import Foundation

class Post {
    private var postId:String
    private var creator:User
    private var matchingStatus:String // MATCHING, WAITING_OTHER_TO_RESPOND, COMFIRMED_BY_OTHER, REJECTED, ACCEPTED
    private var matchedPost:Post? = nil
    private var matchedUser:User? = nil
    private var startTime:Date
    private var endTime:Date
    private var restaurant:String
    private var cuisine:String
    private var notes:String
    
    init(postId:String, creator:User, matchingStatus:String, startTime:Date, endTime:Date, restaurant:String, cuisine:String, notes:String ) {
        self.postId = postId
        self.creator = creator
        self.matchingStatus = matchingStatus
        self.startTime = startTime
        self.endTime = endTime
        self.restaurant = restaurant
        self.cuisine = cuisine
        self.notes = notes
    }
    
    public func getCreator() -> User {
        return self.creator
    }

    public func getRestaurant() -> String {
        return self.restaurant
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
        dateFormatter.dateFormat = "HH:mm"
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
        let post1 = Post(postId:"123", creator: userOne, matchingStatus: "matched", startTime: startTime1!, endTime: endTime1!, restaurant: "Chinese", cuisine: "Chinese Cuisine", notes: "")
        let post2 = Post(postId:"234", creator: userTwo, matchingStatus: "matched", startTime: startTime1!, endTime: endTime1!, restaurant: "Korean", cuisine: "Chinese Cuisine", notes: "")
        
        //post3 & post 4, no matches and put them into the main screen
        let post3 = Post(postId:"345", creator: userThree, matchingStatus: "no-matches", startTime: startTime2!, endTime: endTime2!, restaurant: "Thai", cuisine: "Thai Cuisine", notes: "We can eat Spring Kitchen!")
        let post4 = Post(postId:"456", creator: userFour, matchingStatus: "no-matches", startTime: startTime2!, endTime: endTime2!, restaurant: "Japanese", cuisine: "Pizza", notes: "Maybe hamburger too.")
        
        //post5 posted first and there is no matches, post 6 has same content with post5, so post6 found match(which is post5), but he is waiting for post5 response right now.
        let post5 = Post(postId:"789", creator: userFive, matchingStatus: "no-matches", startTime: startTime3!, endTime: endTime3!, restaurant: "American", cuisine: "pho/noodle", notes: "")
        let post6 = Post(postId:"890", creator: userSix, matchingStatus: "waitingResponse", startTime: startTime3!, endTime: endTime3!, restaurant: "Anything", cuisine: "pho/noodle", notes: "")
        
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
}

