//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/18.
//

import UIKit

class ExploreController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    // MARK: - Helpers
  
    func configureUI() {
        view.backgroundColor = .white
        
        navigationItem.title = "탐색"
        
    }
}
