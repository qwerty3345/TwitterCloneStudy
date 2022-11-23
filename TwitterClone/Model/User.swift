//
//  User.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/20.
//

import Foundation
import FirebaseAuth

struct User {
    let email: String
    let username: String
    let fullname: String
    var profileImageUrl: URL?
    let uid: String
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    // dictionary 값을 바탕으로 객체 생성
    init(uid: String, dict: [String: AnyObject]) {
        self.uid = uid
        
        self.email = dict["email"] as? String ?? ""
        self.username = dict["username"] as? String ?? ""
        self.fullname = dict["fullname"] as? String ?? ""
        if let profileImageUrlString = dict["profileImageUrl"] as? String {
            self.profileImageUrl = URL(string: profileImageUrlString)
        }

    }
}
