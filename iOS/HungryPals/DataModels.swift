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
    private var username:String
    private var userId:String
    private var matchingStatus:String // MATCHING, WAITING_OTHER_TO_RESPOND, COMFIRMED_BY_OTHER, REJECTED, ACCEPTED
    private var matchedUsername:String = ""
    private var matchedUserId:String = ""
    private var matchedUserPic:String = ""
    private var startTime:Date
    private var endTime:Date 
    private var restaurant:String
    private var cuisine:String
    
    
    init(postId:String, username:String, userId:String, matchingStatus:String, startTime:Date, endTime:Date, restaurant:String, cuisine:String ) {
        self.postId = postId
        self.username = username
        self.userId = userId
        self.matchingStatus = matchingStatus
        self.startTime = startTime
        self.endTime = endTime
        self.restaurant = restaurant
        self.cuisine = cuisine
    }
    
    func getMatched(matchedUsername:String, matchedUserId:String, matchedUserPic:String) {
        self.matchedUserId = matchedUserId
        self.matchedUsername = matchedUsername
        self.matchedUserPic = matchedUserPic
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
