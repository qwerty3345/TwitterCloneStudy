//
//  ExploreController.swift
//  TwitterClone
//
//  Created by Mason Kim on 2022/11/18.
//

import UIKit

private let reuseIdentifier = "UserCell"

final class ExploreController: UITableViewController {

    // MARK: - Properties

    var users = [User]() {
        didSet { tableView.reloadData() }
    }

    // 검색 입력 값을 바탕으로 검색한 유저들 목록
    var filteredUser = [User]() {
        didSet { tableView.reloadData() }
    }

    // 검색을 위한 UISearchController
    private let searchController = UISearchController(searchResultsController: nil)

    // 검색 중인지 판별하는 Bool 계산 속성
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchUsers()
        configureSearchController()
    }

    // MARK: - API
    func fetchUsers() {
        UserService.fetchUsers { users in
            self.users = users
        }
    }

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .white

        navigationItem.title = "탐색"
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }

    // UISearchController 구성 설정
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "사용자 검색"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
}

// MARK: - UITableViewDelegate

extension ExploreController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filteredUser.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as! UserCell

        let user = isSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
        cell.user = user

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        let vc = ProfileController(user: user)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension ExploreController: UISearchResultsUpdating {
    // 사용자 SearchController 텍스트 입력 시 결과 업뎃
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }

        filteredUser = users.filter {
            $0.username.contains(searchText) ||
            $0.fullname.contains(searchText)
        }
    }

}
