//
//  ProfileController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/23.
//

import UIKit

private let reuseIdentifier = "ProfileTweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {

    // MARK: - Properties

    private let user: User
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }

    // MARK: - Lifecycle

    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweets()
    }

    override func viewWillAppear(_ animated: Bool) {
        // TODO: 39강) 네비게이션 바를 숨기는 코드를 viewWillAppear에서 처리해야 하는 이유가 뭘까??
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black   // 상태창 글씨 하얗게 만듬
        // 40강) status bar를 지키고 그 밑에서부터 header 의 색상이 들어가는 문제 해결
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    // MARK: - API
    
    func fetchTweets() {
        TweetService.fetchTweets(forUser: user) { tweets in
            print("profile fetch ")
            self.tweets = tweets
            print(tweets)
        }
    }
    
    // MARK: - Helpers

    func configureCollectionView() {

        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }

}

// MARK: - UICollectionViewDataSource
extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileController {
    // Profile Header View 등록
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
            withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        header.viewModel = ProfileHeaderViewModel(user: user)
        header.delegate = self
        return header
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileController: UICollectionViewDelegateFlowLayout {
    // 헤더 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }

    // 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    
    
    
}
