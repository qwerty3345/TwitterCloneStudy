//
//  Tweet.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/22.
//

import Foundation

struct Tweet {
    let caption: String
    let tweetID: String
    let uid: String
    let like: Int
    var timestamp: Date!
    let retweetCount: Int
    let user: User
    
    // dictionary 값을 바탕으로 객체 생성
    init(user: User, tweetID: String, dict: [String: Any]) {
        self.user = user
        self.tweetID = tweetID
        
        self.caption = dict["caption"] as? String ?? ""
        self.uid = dict["uid"] as? String ?? ""
        self.like = dict["like"] as? Int ?? 0
        self.retweetCount = dict["retweetCount"] as? Int ?? 0
        
        if let timestamp = dict["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        

    }
}
