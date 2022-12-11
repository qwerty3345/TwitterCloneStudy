//
//  ProfileHeader.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/23.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func handleDismissal()
    func handleEditProfileFollow(_ header: ProfileHeader)
}

class ProfileHeader: UICollectionReusableView {

    // MARK: - Properties

    var viewModel: ProfileHeaderViewModel? {
        didSet { configure() }
    }

    weak var delegate: ProfileHeaderDelegate?


    private let filterBar = ProfileFilterView()

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 42, paddingLeft: 16)
        backButton.setDimensions(width: 30, height: 30)
        return view
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()

    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        return iv
    }()

    private lazy var editProfileFollowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("로딩 중", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollowTapped), for: .touchUpInside)
        return button
    }()


    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()

    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.textColor = .black
        return label
    }()

    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()

    private let followingLabel: UILabel = {
        let label = UILabel()

        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)

        return label
    }()


    private let followersLabel: UILabel = {
        let label = UILabel()

        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(followTap)

        return label
    }()




    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        filterBar.delegate = self

        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 100)

        addSubview(profileImageView)
        profileImageView.anchor(top: containerView.bottomAnchor, left: leftAnchor,
            paddingTop: -24, paddingLeft: 8) // paddingTop -24 줌으로서 containerView와 겹치게 만듬.
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2

        addSubview(editProfileFollowButton)
        editProfileFollowButton.anchor(top: containerView.bottomAnchor, right: rightAnchor,
            paddingTop: 12, paddingRight: 12)
        editProfileFollowButton.setDimensions(width: 100, height: 36)
        editProfileFollowButton.layer.cornerRadius = 36 / 2

        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        addSubview(userDetailStack)
        userDetailStack.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, right: rightAnchor,
            paddingTop: 8, paddingLeft: 12, paddingRight: 12)

        addSubview(filterBar)
        filterBar.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, height: 50)

        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor, width: frame.width / 3, height: 2)

        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        addSubview(followStack)
        followStack.anchor(top: userDetailStack.bottomAnchor, left: leftAnchor,
            paddingTop: 8, paddingLeft: 12)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Action

    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }

    @objc func handleEditProfileFollowTapped() {
        
        // ⭐️ 함수의 중복 호출 방지. UI 업데이트 후, CollectionView의 reloadData 가 실행되니 Header의 configure에서 true로 지정!
        self.isUserInteractionEnabled = false

        delegate?.handleEditProfileFollow(self)
    }

    @objc func handleFollowingTapped() {

    }

    @objc func handleFollowersTapped() {

    }

    // MARK: - Helpers

    func configure() {
        followersLabel.attributedText = viewModel?.followersString
        followingLabel.attributedText = viewModel?.followingString
        profileImageView.sd_setImage(with: viewModel?.profileImageUrl)
        usernameLabel.text = viewModel?.username
        fullnameLabel.text = viewModel?.fullname
        editProfileFollowButton.setTitle(viewModel?.actionButtonTitle, for: .normal)
        editProfileFollowButton.setTitleColor(viewModel?.actionButtonTextColor, for: .normal)
        editProfileFollowButton.backgroundColor = viewModel?.actionButtonBackgroundColor
        
        self.isUserInteractionEnabled = true
    }

}

// MARK: - ProfileFilterViewDelegate
extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        // ⭐️ collectionView.cellForItem(at:) 으로 해당 indexPath의 cell을 가져올 수 있다!
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else { return }

        // ⭐️ 어떤 뷰의 x축 위치로 다른 뷰를 움직이고 싶을 때:
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
