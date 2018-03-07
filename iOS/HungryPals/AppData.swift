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
}
