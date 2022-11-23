//
//  UploadTweetController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/21.
//

import UIKit

final class UploadTweetController: UIViewController {

    // MARK: - Properties

    private let user: User

    // TODO: 26강) lazy var 를 사용해야 하는 이유, 또 어떤 버튼은 addTarget을 해도 let인 이유.
    private lazy var tweetActionButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .twitterBlue
        button.setTitle("트윗", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)

        // 두 가지 방식 모두 가능.
//        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.setDimensions(width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2

        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)

        return button
    }()

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .lightGray
        return iv
    }()

    private let captionTextView = CaptionTextView()


    // MARK: - Lifecycle

    // ⭐️ user 객체 의존성 주입(?)
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()


        configureUI()
    }

    // MARK: - Actions

    @objc func handleCancel() {
        dismiss(animated: true)
    }


    // MARK: - API
    
    @objc func handleUploadTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.uploadTweet(caption: caption) { error, ref in
            if let error {
                print("DEBUG: 트윗 업로드 에러 - \(error.localizedDescription)")
                return
            }
            
            self.dismiss(animated: true)
        }
    }

    

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white
        configureNavigationBar()

        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12

        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor,
            left: view.leftAnchor, right: view.rightAnchor,
            paddingTop: 16, paddingLeft: 16, paddingRight: 16)

        // sd_WebImage의 캐싱 기능으로 이미 이전에 다운로드 한 이미지를 넣어줌.
        profileImageView.sd_setImage(with: user.profileImageUrl)
    }

    func configureNavigationBar() {
        let leftBarItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        leftBarItem.tintColor = .twitterBlue
        navigationItem.leftBarButtonItem = leftBarItem
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetActionButton)

    }
}
