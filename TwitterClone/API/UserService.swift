//
//  UserService.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/20.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

/// 유저 관련 API 서비스
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
    
    /// 유저 팔로우 (followers, following 에 각각 DB 업데이트)
    static func followUser(withUid uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        REF_USER_FOLLOWING.child(currentUid).setValue([uid: 1]) { error, ref in
            REF_USER_FOLLOWERS.child(uid).setValue([currentUid: 1], withCompletionBlock: completion)
        }
    }
    
    /// 유저 언팔로우 (followers, following 에 각각 DB 업데이트)
    static func unfollowUser(withUid uid: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).removeValue() { error, ref in
            REF_USER_FOLLOWERS.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    /// 해당 유저를 팔로우 하고 있는 상태인지 확인
    static func checkIfUserIsFollowed(withUid uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            // snapshot이 존재하면 followed 상태이므로 completion 실행
            completion(snapshot.exists())
        }
    }
    
    static func fetchUserStats(withUid uid: String, completion: @escaping (UserRelationStats) -> Void) {
        
        REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
            let following = snapshot.children.allObjects.count
            REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
                let followers = snapshot.children.allObjects.count
                
                let stats = UserRelationStats(following: following, followers: followers)
                completion(stats)
            }
        }
    }
}
