//
//  CaptionTextView.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/22.
//

import UIKit

class CaptionTextView: UITextView {

    // MARK: - Properties
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.text = "무슨 일이 있었나요?"
        return label
    }()


    // MARK: - Lifecycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        font = .systemFont(ofSize: 16)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 300).isActive = true

        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor,
            paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChanged), name: UITextView.textDidChangeNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 사용자 텍스트 입력에 따라 placeholder 숨김
    @objc func handleTextInputChanged() {
        placeholderLabel.isHidden = !text.isEmpty
    }

}
