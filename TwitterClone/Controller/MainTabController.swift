//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/18.
//

import UIKit
import FirebaseAuth

final class MainTabController: UITabBarController {

    // MARK: - Properties
    var user: User? {
        didSet {
            // ⭐️24강) MainTabController의 viewControllers 계층 구조 : 노션에 정리.
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        view.backgroundColor = UIColor.twitterBlue

        authenticateUserAndConfigureUI()
    }

//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        AuthenticateUserAndConfigureUI()
//    }


    // MARK: - API

    /// 유저 인증 및 UI 구성
    func authenticateUserAndConfigureUI() {
        
        // 유저 정보 존재 유무 확인
        if Auth.auth().currentUser == nil {
            //⭐️ DispatchQueue 로 메인 스레드에서 비동기로 실행해야 하는 이유는? (19강)
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true)
            }
        } else {
            configureUI()
            configureViewControllers()
            fetchUser()
        }
    }

    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }

    func userLogOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: 유저 로그아웃 에러 \(error.localizedDescription)")
        }
    }


    // MARK: - Actions

    @objc func actionButtonTapped() {
        guard let user else { return }
        let nav = UINavigationController(rootViewController: UploadTweetController(user: user))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }


    // MARK: - Helpers

    /// UI 구성
    func configureUI() {
        view.backgroundColor = .white
        tabBar.backgroundColor = .white.withAlphaComponent(0.5)
        tabBar.tintColor = UIColor.twitterBlue

        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
            paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2

    }

    /// TabBar의 ViewController 들을 설정
    func configureViewControllers() {

        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(withImage: UIImage(named: "home_unselected"), rootViewController: FeedController(collectionViewLayout: layout))

        let explore = templateNavigationController(withImage: UIImage(named: "search_unselected"), rootViewController: ExploreController())

        let notification = templateNavigationController(withImage: UIImage(named: "like_unselected"), rootViewController: NotificationController())

        let conversation = templateNavigationController(withImage: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: ConversationController())

        viewControllers = [feed, explore, notification, conversation]
    }

    /// TabBar의 각 요소가 되는 ViewController들을 NavigationController로 만들고 기본 아이콘 이미지를 설정
    func templateNavigationController(withImage image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white.withAlphaComponent(0.5)
        return nav
    }



}
