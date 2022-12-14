//
//  Constants.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/19.
//

import FirebaseDatabase
import FirebaseStorage


// MARK: - Firebase Storage 축약 Constants
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profile_images")

// MARK: - Firebase RealtimeDatabase 축약 Constants
let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("users")
let REF_TWEETS = DB_REF.child("tweets")
let REF_USER_TWEETS = DB_REF.child("user-tweets")
let REF_USER_FOLLOWERS = DB_REF.child("user-followers")
let REF_USER_FOLLOWING = DB_REF.child("user-following")
