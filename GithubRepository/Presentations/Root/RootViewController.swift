//
//  RootViewController.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/08.
//

import UIKit

import Then

class RootViewController: UIViewController {
    
    private let organization = "Apple"
    
    
    // MARK: - Enum
    
    private enum Text {
        static let navigationTitle = " Repositories"
        static let refreshTitle = "당겨서 새로고침"
    }
    
    
    // MARK: - UI
    
    private lazy var RepositoryList = UITableView().then {
        $0.refreshControl = UIRefreshControl().then { /// 리스트 당겨서 새로고침
            $0.backgroundColor = .white
            $0.tintColor = .darkGray
            $0.attributedTitle = NSAttributedString(string: Text.refreshTitle)
            $0.addTarget(self, action: #selector(self.didDragRefreshControl), for: .valueChanged)
        }
        
        $0.rowHeight = 140
        $0.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.RepositoryList
        self.title = self.organization + Text.navigationTitle
    }
    
    
    // MARK: - Methods
    
    @objc func didDragRefreshControl() {
        print("새로고침 실행됨")
    }
    
}


// MARK: - UITableViewDataSource

extension RootViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else { return UITableViewCell() }
        
        return cell
    }
    
}


// MARK: - UITableViewDelegate

extension RootViewController: UITableViewDelegate {

}
