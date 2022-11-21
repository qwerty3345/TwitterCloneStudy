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
    /// 현재 로그인한 user 정보를 받아옴.
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
}
