//
//  TweetService.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/22.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

struct TweetService {
    static func uploadTweet(caption: String, completon: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let values: [String : Any] = ["uid": uid,
            "timestamp": Int(Date().timeIntervalSince1970),   // Firestore RealtimeDB 에서 timestamp 구현방식.
            "likes": 0,
            "retweets": 0,
            "caption": caption]

        REF_TWEETS.childByAutoId().updateChildValues(values, withCompletionBlock: completon)
        
    }
    
    static func fetchTweets(completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        // 새로운 자식이 추가 될 때 마다 observe 해서 가져옴. / 처음 실행될 때는 모든 자식을 하나씩 가져옴.
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dict = snapshot.value as? [String: Any] else { return }
            guard let uid = dict["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.fetchUser(withUid: uid) { user in
                let tweet = Tweet(user: user, tweetID: tweetID, dict: dict)
                tweets.append(tweet)
                
                // TODO: 트윗이 하나 추가 될 때 마다 한 번씩 호출되는 건 괜찮은데, 앱을 키고 처음에 데이터를 가져올 때 Tweet 객체의 갯수만큼 completion 이 실행되는 문제는 어떻게 해결하지?
                completion(tweets.reversed())
            }
        }
        
        /**
        // DispatchGroup 객체 생성
        let fetchTweetsDispatchGroup = DispatchGroup()
        
        print("fetchTweets 시작")
        REF_TWEETS.observe(.childAdded) { snapshot in
            
            // 작업을 시작할 때, DispatchGroup의 task reference count를 +1 해줌.
            fetchTweetsDispatchGroup.enter()
            
            print("fetchTweets getData")
            guard let dict = snapshot.value as? [String: Any] else { return }
            let tweetID = snapshot.key
            
            let tweet = Tweet(tweetID: tweetID, dict: dict)
            tweets.append(tweet)
            
            fetchTweetsDispatchGroup.leave()
        }
        
        // DispatchGroup의 task reference가 0이 된 시점에 실행함.
        fetchTweetsDispatchGroup.notify(queue: .main) {
            print("fetchTweets 종료")
            completion(tweets)
        }
         */
        
        
    }
}
