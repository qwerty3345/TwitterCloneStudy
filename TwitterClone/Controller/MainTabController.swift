//
//  MainTabController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/18.
//

import UIKit

class MainTabController: UITabBarController {

    // MARK: - Properties

    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = UIColor.twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(MainTabController.self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureViewControllers()

    }
    
    // MARK: - Actions
    
    @objc func actionButtonTapped() {
        print("action")
    }
    

    // MARK: - Helpers

    func configureUI() {
        tabBar.backgroundColor = .white.withAlphaComponent(0.5)
        tabBar.tintColor = UIColor.twitterBlue

        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
            paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2

    }

    /// TabBar의 ViewController 들을 설정
    func configureViewControllers() {

        let feed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: FeedController())

        let explore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreController())

        let notification = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: NotificationController())

        let conversation = templateNavigationController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: ConversationController())

        viewControllers = [feed, explore, notification, conversation]
    }

    /// TabBar의 각 요소가 되는 ViewController들을 NavigationController로 만들고 기본 아이콘 이미지를 설정
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white.withAlphaComponent(0.5)
        return nav
    }



}
