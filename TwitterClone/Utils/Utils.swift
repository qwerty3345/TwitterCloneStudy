//
//  Utils.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/19.
//

import UIKit

struct Utils {
    /// 아이콘 image, 입력 TextField를 포함하는 ContainerView 를 반환
    func inputContainerView(withImage image: UIImage?, textField: UITextField) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let iv = UIImageView()
        iv.image = image
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .white
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = .white
        view.addSubview(dividerView)
        dividerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, height: 1)
        
        return view
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = .systemFont(ofSize: 16)
        // ⭐️ textField의 placeholder 속성 변경은 attributedPlaceholder로 지정 가능.
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.white])
        return tf
    }
    
    /// 첫 파라미터로 기본 텍스트, 두번째 파라미터로 볼드 효과가 있는 텍스트를 받아서 텍스트 형태 버튼 생성
    func attributedTextButton(firstPlainText: String, secondBoldText: String) -> UIButton {
        let button = UIButton(type: .system)
        let attrString = NSMutableAttributedString(string: firstPlainText, attributes: [.font: UIFont.systemFont(ofSize: 16)])
        attrString.append(NSAttributedString(string: secondBoldText, attributes: [.font: UIFont.boldSystemFont(ofSize: 16)]))
        button.setAttributedTitle(attrString, for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
}

class Timer {
    static let shared = Timer()
    
    var time = CFAbsoluteTimeGetCurrent()
    
    func startTimer() {
        self.time = CFAbsoluteTimeGetCurrent()
    }

    func endTimer() {
        let durationTime = CFAbsoluteTimeGetCurrent() - time
        print("경과 시간: \(durationTime)")
    }

}

/// ⭐️ keyWindow를 구하기 위한 전역 변수 (keyWindow의 직접 접근이 deprecated 되었기 때문에)
let keyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first
