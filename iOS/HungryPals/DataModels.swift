//
//  DataModels.swift/Users/iguest/Desktop/HungryPals/iOS/HungryPals/Post.swift
//  HungryPals
//
//  Created by Leon T Long on 3/1/18.
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
