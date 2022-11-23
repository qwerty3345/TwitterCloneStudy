//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/22.
//

import UIKit

struct TweetViewModel {

    let tweet: Tweet
    let user: User

    var profileImageUrl: URL? { return user.profileImageUrl }

    var captionText: String { return tweet.caption }

    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated // 가장 축약된 스타일 (ex “3y 9mo 26d 19h 17s”)
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? ""
    }

    // @mason · 3초전
    var userInfoText: NSAttributedString {
        let attributedText = NSMutableAttributedString(string: user.fullname,
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " @\(user.username) · \(timestamp)",
            attributes: [.font: UIFont.systemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }



    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }


}
