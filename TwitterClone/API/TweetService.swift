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
    /// 트윗 게시글 업로드
    static func uploadTweet(caption: String, completion: @escaping (Error?, DatabaseReference) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let values: [String: Any] = ["uid": uid,
            "timestamp": Int(Date().timeIntervalSince1970), // Firestore RealtimeDB 에서 timestamp 구현방식.
            "likes": 0,
            "retweets": 0,
            "caption": caption]

        // 1.🔥 tweets DB에 트윗 추가
        REF_TWEETS.childByAutoId().updateChildValues(values) { err, ref in
            guard let tweetID = ref.key else { return }
            // 2.🔥 user-tweets DB에 업로드한 유저의 uid 내부에 tweetID 저장 (user-feed 목록을 쉽게 불러오기 위해)
            REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 0], withCompletionBlock: completion)
        }

    }

    /// 트윗 게시글들 가져오기
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
    }

    /// 특정 유저의 트윗 게시글들 가져오기
    static func fetchTweets(forUser user: User, completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()

        // 새로운 자식이 추가 될 때 마다 observe 해서 가져옴. / 처음 실행될 때는 모든 자식을 하나씩 가져옴.
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            // user-tweets 에는 tweetID 만 담겨있음
            let tweetID = snapshot.key
            
            // tweetID를 바탕으로 tweet 객체 생성하고 배열에 담음. / 한 번만 실행되면 되기에 singleEvent(of: .value)로 호출
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dict = snapshot.value as? [String: Any] else { return }
                let tweet = Tweet(user: user, tweetID: tweetID, dict: dict)
                tweets.append(tweet)
                // TODO: 동일하게 completion이 너무 많이 호출되는 문제...
                completion(tweets.reversed())
            }
        }
    }

}
