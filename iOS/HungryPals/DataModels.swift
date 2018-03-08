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
    private var username:String
    private var userId:String
    private var matchingStatus:String // MATCHING, WAITING_OTHER_TO_RESPOND, COMFIRMED_BY_OTHER, REJECTED, ACCEPTED
    private var matchedUsername:String
    private var matchedUserId:String
    private var startTime:Date
    private var endTime:Date
    private var restaurant:String
    private var cuisine:String
    
    
    init(postId:String, username:String, userId:String, matchingStatus:String, matchedUsername:String, matchedUserId:String, startTime:Date, endTime:Date, restaurant:String, cuisine:String ) {
        self.postId = postId
        self.username = username
        self.userId = userId
        self.matchingStatus = matchingStatus
        self.matchedUsername = matchedUsername
        self.matchedUserId = matchedUserId
        self.startTime = startTime
        self.endTime = endTime
        self.restaurant = restaurant
        self.cuisine = cuisine
    }
    
    public func getRestaurant() -> String {
        return self.restaurant
    }
}

class User {
    private var username:String
    private var userId:String
    private var profilePic:String
    private var cuisinePrefs:[String] = []
    private var deviceToken:String = ""
    private var friendList:String
    
    init(username:String, userId:String, profilePic:String, friendList:String) {
        self.username = username
        self.userId = userId
        self.profilePic = profilePic
        self.friendList = friendList
    }
    
    public func setDeviceToken(_ deviceToken:String) {
        self.deviceToken = deviceToken
    }
    
    public func setCuisinePrefs(_ cuisinePrefs:[String]) {
        self.cuisinePrefs = cuisinePrefs
    }
}

class PostRepository {
    private var posts = [Post]()
    
    static let shared = PostRepository()
    
    func getPosts() -> [Post] {
        return posts
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
