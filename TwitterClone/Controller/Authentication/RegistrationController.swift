//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/19.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


final class RegistrationController: UIViewController {

    // MARK: - Properties

    private let imagePicker = UIImagePickerController()
    private var profileImage: UIImage?

    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system) // ⭐️ tintColor가 적용 안돼서 알아보니, system 타입으로 지정하지 않아서 그랬음.
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true // button의 형태에 따라 내부의 image가 같이 잘리게 함
        return button
    }()

    private lazy var emailContainerView: UIView = {
        let view = Utils().inputContainerView(withImage: UIImage(named: "mail"), textField: emailTextField)
        return view
    }()

    private lazy var passwordContainerView: UIView = {
        let view = Utils().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x"), textField: passwordTextField)
        return view
    }()

    private lazy var fullnameContainerView: UIView = {
        let view = Utils().inputContainerView(withImage: UIImage(named: "ic_person_outline_white_2x"), textField: fullnameTextField)
        return view
    }()

    private lazy var usernameContainerView: UIView = {
        let view = Utils().inputContainerView(withImage: UIImage(named: "ic_person_outline_white_2x"), textField: usernameTextField)
        return view
    }()


    private let emailTextField: UITextField = {
        let tf = Utils().textField(withPlaceholder: "이메일")
        return tf
    }()

    private let passwordTextField: UITextField = {
        let tf = Utils().textField(withPlaceholder: "비밀번호")
        tf.isSecureTextEntry = true // 비밀번호 입력 시 **** 처럼 안보이게 표기
        return tf
    }()

    private let fullnameTextField: UITextField = {
        let tf = Utils().textField(withPlaceholder: "유저 풀네임")
        return tf
    }()

    private let usernameTextField: UITextField = {
        let tf = Utils().textField(withPlaceholder: "닉네임")
        return tf
    }()

    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(UIColor.twitterBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        return button
    }()

    private let alreadyHaveAccountButton: UIButton = {
        let button = Utils().attributedButton("이미 계정이 있습니까? ", "로그인")
        button.addTarget(self, action: #selector(handleShowSignIn), for: .touchUpInside)
        return button
    }()



    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Actions

    // 로그인 창으로 이동
    @objc func handleShowSignIn() {
        navigationController?.popViewController(animated: true)
    }

    // 유저 회원가입
    @objc func handleRegistration() {

        // 각 입력창의 값이 없으면 해당 View에 Shake 애니메이션 주고 Return.
        guard let profileImage else {
            plusPhotoButton.shake()
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            emailContainerView.shake()
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            passwordContainerView.shake()
            return
        }
        // username은 항상 소문자로 처리
        guard let username = usernameTextField.text?.lowercased(), !username.isEmpty else {
            usernameContainerView.shake()
            return
        }
        guard let fullname = fullnameTextField.text, !fullname.isEmpty else {
            fullnameContainerView.shake()
            return
        }



        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        AuthService.registerUser(withCredentials: credentials) { error, ref in
            // ⭐️ 회원가입 완료 후 dismiss 하기 전에 configureUI를 실행.
            guard let tab = keyWindow?.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true)
        }


    }

    @objc func handleAddProfilePhoto() {
        present(imagePicker, animated: true)
    }


    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.twitterBlue
        // 네비게이션 바의 글씨 색을 흰색으로 만들어줌. (black barStyle)
        navigationController?.navigationBar.barStyle = .black

        imagePicker.delegate = self
        imagePicker.allowsEditing = true // 선택 후 확대,축소해서 크롭 가능하게 함.

        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        plusPhotoButton.layer.cornerRadius = 128 / 2

        let stack = UIStackView(arrangedSubviews: [
            emailContainerView,
            passwordContainerView,
            fullnameContainerView,
            usernameContainerView,
            signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
//        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
            paddingLeft: 16, paddingRight: 16)

        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)

    }

}

// MARK: - UIImagePickerControllerDelegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // ImagePicker 선택 완료 후,
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        // ⭐️ 항상 원본 이미지가 나타나게 renderingMode 지정. 아니면 흰 화면으로 뜸.
        profileImage = selectedImage.withRenderingMode(.alwaysOriginal)
        plusPhotoButton.setImage(profileImage, for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 2
        imagePicker.dismiss(animated: true)
    }
}
