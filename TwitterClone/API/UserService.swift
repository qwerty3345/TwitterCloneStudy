//
//  UserService.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

struct UserService {
    /// 현재 로그인한 user 정보를 가져옴.
    static func fetchUser(completion: @escaping (User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            // DataSnapshot 형태의 객체를 swift Dictionary 형태로 매핑
            guard let dict = snapshot.value as? [String: AnyObject] else { return }
            // User 객체 생성 후 completion 실행
            let user = User(uid: uid, dict: dict)
            completion(user)
        }
    }
    
    /// 특정 uid 에 해당하는 user 정보를 가져옴.
    static func fetchUser(withUid uid: String, completion: @escaping (User) -> Void) {
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            guard let dict = snapshot.value as? [String: AnyObject] else { return }
            let user = User(uid: uid, dict: dict)
            completion(user)
        }
    }
    
    /// 모든 user들을 가져옴.
    static func fetchUsers(completion: @escaping (([User]) -> Void)) {
        var users = [User]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dict = snapshot.value as? [String: AnyObject] else { return }
            
            let user = User(uid: uid, dict: dict)
            users.append(user)
            // TODO: 동일하게 completion 여러번 실행되는 문제ㅠㅠ
            completion(users)
        }
    }
}
