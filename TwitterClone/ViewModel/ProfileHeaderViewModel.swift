//
//  ProfileHeaderViewModel.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/23.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes

    var description: String {
        switch self {
        case .tweets: return "트윗"
        case .replies: return "트윗 및 답글"
        case .likes: return "좋아요"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User

    var followersString: NSAttributedString? { return attributedText(withValue: user.stats?.followers ?? 0, text: "팔로워") }

    var followingString: NSAttributedString? { return attributedText(withValue: user.stats?.following ?? 0, text: "팔로잉") }

    // ⭐️54강) 로딩 중 로직 구현
    var actionButtonTitle: String {
        if user.isCurrentUser { return "프로필 수정" }
        guard let isFollwed = user.isFollwed else { return "로딩중" }
        return isFollwed ? "팔로잉" : "팔로우"
    }

    var actionButtonBackgroundColor: UIColor {
        if user.isCurrentUser { return .white }
        guard let isFollwed = user.isFollwed else { return .white }
        return isFollwed ? .white : .twitterBlue
    }

    var actionButtonTextColor: UIColor {
        if user.isCurrentUser { return .black }
        guard let isFollwed = user.isFollwed else { return .black }
        return isFollwed ? .twitterBlue : .white
    }
    
    var profileImageUrl: URL? { return user.profileImageUrl }

    var username: String { return "@\(user.username)" }

    var fullname: String { return user.fullname }

  

    init(user: User) {
        self.user = user
    }

    // TODO: 44강) private이 아닌, fileprivate 으로 선언하는 이유는??
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "\(value)",
            attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(text)",
            attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        return attributedText
    }

}
