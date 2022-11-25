//
//  AuthService.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/19.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

// TODO: ⭐️ shared 객체를 생성해 싱글턴 방식으로 사용하는 것과, static func 로 사용하는 것의 차이는?? 메모리 구조 측면에서.
// static func 내부에서는 struct 내부의 멤버 변수를 사용하지 못한다는 특징이 있는데, 해당 AuthService는 멤버 변수가 없기에 static func 사용해도 상관 없을 듯 함.
// 또한, shared 형식의 싱글턴을 채택할 시에는, 모든 객체가 동일한 객체라는 특징을 가질 수 있는데, 그럴 필요가 굳이 없기 때문에...
// 객체를 한 번만 생성해도 되는 것이 장점이지만 그렇다고 static func를 사용하는 것에 비해서 메모리 이상의 이점을 가지지도 못함.


// TODO: ⭐️ AuthCredentials 이라는 이름보다, 어차피 모델 역할을 하는 아이니까, User 라는 모델 객체를 쓰는게 낫지 않을까? -> 근데 그러면 User는 profileImageUrl을 가져야 하는데 얘는 UIImage를 직접 가지고, 또한 아직 uid가 없으니 모델의 형태가 다르겠구나!
/// 사용자 회원가입 등의 액션에 필요한 필드를 담고 있는 Model struct
struct AuthCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

typealias AuthDataResultCallback = (AuthDataResult?, Error?) -> Void

/// 회원가입, 로그인 등 유저 인증과 관련 된 API Service
struct AuthService {
    
    static func loginUser(withEmail email: String, password: String, completion: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            completion(result, error)
        }
    }
    
    /// 회원가입 (FirebaseAuth)
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }

        let fileName = NSUUID().uuidString // 파일명을 위한 랜덤한 UUID String 생성
        let storageRef = STORAGE_PROFILE_IMAGES.child(fileName)

        //🔥 1. 프로필 사진 저장 (Firebase Storage)
        storageRef.putData(imageData) { metadata, error in
            // 업로드 한 사진의 다운로드 가능한 url 주소로 completion 실행
            storageRef.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else { return }

                //🔥 2. 회원가입 (Firebase Auth)
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                    if let error {
                        print("DEBUG: 회원가입 에러 - \(error.localizedDescription)")
                        return
                    }

                    // 회원가입에 성공한 user의 uid값
                    guard let uid = result?.user.uid else { return }
                    let values = ["email": credentials.email,
                        "username": credentials.username,
                        "fullname": credentials.fullname,
                        "profileImageUrl": profileImageUrl]
                    let ref = REF_USERS.child(uid) // Firebase RealtimeDB reference

                    //🔥 3. 회원 정보 저장 (Firebase RealtimeDB), ⭐️ 이후 completion 실행
                    ref.updateChildValues(values, withCompletionBlock: completion)
                }
            }
        }
    }


}
