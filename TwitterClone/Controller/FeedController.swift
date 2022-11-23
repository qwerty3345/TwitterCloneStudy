//
//  FeedController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/18.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

final class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configureLeftBarButton()
        }
    }
    
    var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchTweet()
    }
    
    // MARK: - API
    
    func fetchTweet() {
        TweetService.fetchTweets { tweets in
            print("completion 실행")
            self.tweets = tweets
        }
    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
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

// MARK: - UICollectionViewDelegate/DataSource
extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        cell.delegate = self
        return cell
    }

    
}

// MARK: - UICollectionViewFlowLayout (셀들의 사이즈, 간격)
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.viewModel?.user else { return }
        let vc = ProfileController(user: user, collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
