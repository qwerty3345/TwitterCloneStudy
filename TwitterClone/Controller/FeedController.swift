//
//  FeedController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/18.
//

import UIKit
import SDWebImage

final class FeedController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        // 네비게이션 바의 타이틀뷰를 트위터 로고 이미지로 설정
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
       
    }

    /// 네비게이션바에 유저 프로필 이미지 삽입
    func configureLeftBarButton() {
        guard let user else { return }
        let profileImageView = UIImageView()
        profileImageView.backgroundColor = .white
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.clipsToBounds = true
        
        // TODO: sd_webImage 라이브러리를 사용하지 않고 띄우는 방법 공부하기
        profileImageView.sd_setImage(with: user.profileImageUrl)
//        profileImageView.setImage(withUrl: user.profileImageUrl)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
    
}
