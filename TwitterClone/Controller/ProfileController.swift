//
//  ProfileController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/23.
//

import UIKit

private let reuseIdentifier = "ProfileTweetCell"
private let headerIdentifier = "ProfileHeader"

final class ProfileController: UICollectionViewController {

    // MARK: - Properties

    private var user: User
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData() }
    }
    
    private let dispachGroup = DispatchGroup()
    private var followToggle = false
    

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
        checkIfUserIsFollwed()
        fetchUserStats()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: 39강) 네비게이션 바를 숨기는 코드를 viewWillAppear에서 처리해야 하는 이유가 뭘까??
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black // 상태창 글씨 하얗게 만듬
        // 40강) status bar를 지키고 그 밑에서부터 header 의 색상이 들어가는 문제 해결
        collectionView.contentInsetAdjustmentBehavior = .never
    }

    // ⭐️ 51강) 매번 다른 컨트롤러에서 네비게이션바 숨김설정을 해제해주는 비효율성 해결
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .default // 상태창 글씨 까맣게 만듬
    }

    // MARK: - API

    func fetchTweets() {
        TweetService.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkIfUserIsFollwed() {
        UserService.checkIfUserIsFollowed(withUid: user.uid) { isFollwed in
            self.user.isFollwed = isFollwed
            self.collectionView.reloadData()
            // ⭐️54강) 팔로우 상태 체크 후, collectionView.reloadData() 를 하면 일어나는 일
        }
    }
    
    func fetchUserStats() {
        UserService.fetchUserStats(withUid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
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
    func handleEditProfileFollow(_ header: ProfileHeader) {
        
        // 현재 유저일 경우 프로필 수정
        if user.isCurrentUser {
            //TODO: 프로필 수정 UI, 기능 구현
            print("DEBUG: 프로필 수정")
            return
        }

        dispachGroup.enter()
        
        // TODO: 팔로우 버튼 연타 시, 계속 팔로워 수치 올라가는 문제 해결.
        // isFollwed가 로딩중(nil)일때는 아무런 동작도 하지 않게끔.
        guard let isFollwed = user.isFollwed else { return }
        if isFollwed {
            // 유저 언팔로우
            UserService.unfollowUser(withUid: user.uid) { error, ref in
                self.user.isFollwed = false
                self.user.stats?.followers -= 1     // ⭐️ 팔로워 수치 업뎃
                self.collectionView.reloadData()
                print("DEBUG: \(self.user.username) 유저 언팔로우")
                self.dispachGroup.leave()
            }
        } else {
            // 유저 팔로우
            UserService.followUser(withUid: user.uid) { error, ref in
                self.user.isFollwed = true
                self.user.stats?.followers += 1     // ⭐️ 팔로워 수치 업뎃
                self.collectionView.reloadData()
                print("DEBUG: \(self.user.username) 유저 팔로우")
                self.dispachGroup.leave()
            }
        }
        
        dispachGroup.notify(queue: .main) {
            print("완료")
        }
    }

    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }




}
