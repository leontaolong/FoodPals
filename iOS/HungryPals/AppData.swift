//
//  AppData.swift
//  HungryPals
//
//  Created by Christy Lu on 3/6/18.
//  Copyright © 2018 UW iSchool. All rights reserved.
//

import Foundation

class AppData: NSObject {
    static let shared = AppData()
    
    open var name = String()
    open var email = String()
    open var profilePicUrl = String()
    open var location = String()
    open var id = String()
    open var fromProfile = false
    open var cuisine: [String] = ["American", "Chinese", "Korean", "Italian", "Japanese", "Mexican", "Indian", "Thai", "Vegan", "Greek"]
    open var cuisineMarked: [Bool] = [false, false, false, false, false, false, false, false, false, false]
    open var accountList: [String] = ["Cuisine Preference", "Live in ", "Terms & privacy policiy", "About Hungry Pals"]
    open var accountListIcon: [String] = ["like", "location", "policy", "about"]
}
