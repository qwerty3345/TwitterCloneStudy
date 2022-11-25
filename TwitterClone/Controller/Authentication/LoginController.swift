//
//  LoginController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/19.
//

import UIKit

final class LoginController: UIViewController {

    // MARK: - Properties

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "TwitterLogo")
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.tintColor = .white
        return iv
    }()

    private lazy var emailContainerView: UIView = {
        let view = Utils().inputContainerView(withImage: UIImage(named: "mail"), textField: emailTextField)
        
        return view
    }()

    private lazy var passwordContainerView: UIView = {
        let view = Utils().inputContainerView(withImage: UIImage(named: "ic_lock_outline_white_2x"), textField: passwordTextField)
        
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
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor.twitterBlue, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 5
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utils().attributedTextButton(firstPlainText: "계정이 없으십니까? ", secondBoldText: "회원가입")
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("### LoginController ViewDidLoad")
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Actions
    
    // 유저 로그인
    @objc func handleLogin() {
        guard let email = emailTextField.text else {
            emailContainerView.shake()
            return
        }
        
        guard let password = passwordTextField.text else {
            passwordContainerView.shake()
            return
        }
        
        AuthService.loginUser(withEmail: email, password: password) { result, error in
            if let error {
                print("DEBUG: 로그인 에러 - \(error.localizedDescription)")
                return
            }
            
            // ⭐️ 로그인 완료 후 dismiss 하기 전에 configureUI를 실행.
            guard let tab = keyWindow?.rootViewController as? MainTabController else { return }
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true)
        }
    }
    
    // 회원가입 창으로 이동
    @objc func handleShowSignUp() {
        let vc = RegistrationController()
        navigationController?.pushViewController(vc, animated: true)
    }
    

    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor.twitterBlue
        // 네비게이션 바의 글씨 색을 흰색으로 만들어줌. (black barStyle)
        navigationController?.navigationBar.barStyle = .black

        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)

        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 16
//        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor,
            paddingLeft: 16, paddingRight: 16)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingBottom: 16, paddingRight: 40)

    }

}
