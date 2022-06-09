//
//  RootViewController.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/08.
//

import UIKit

import RxCocoa
import RxSwift
import RxDataSources
import Then

class RootViewController: UIViewController {
    
    private let organization = "Apple"
    
    private let repositories = BehaviorSubject<[Repository]>(value: [])
    private let disposeBag = DisposeBag()
    
    
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
        self.bindRepositoryList()
    }
    
    
    // MARK: - Bind
    
    private func bindRepositoryList() {
        let repoObservables = self.fetchRepositories(of: self.organization)
        repoObservables
            .bind(to: self.RepositoryList.rx.items) { tableView, index, element -> UITableViewCell in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell") as? RepositoryListCell
                else { return UITableViewCell() }
                
                cell.repository = element
                return cell
            }
            .disposed(by: self.disposeBag)
        
    }
    
    
    // MARK: - Methods
    
    @objc func didDragRefreshControl() {
        self.RepositoryList.refreshControl?.endRefreshing()
    }
    
    private func fetchRepositories(of organization: String) -> Observable<[Repository]> {
        return Observable.from([organization])
            .map { organization -> URLRequest in /// String to  URLRequest
                let url = URL(string: "https://api.github.com/orgs/\(organization)/repos")!
                return URLRequest(url: url)
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .map { _, data -> [Repository] in
                guard let json = try? JSONSerialization.jsonObject(with: data), /// json 파싱
                      let resultArr = json as? [[String: Any]]
                else {
                    return []
                }
    
                return resultArr.compactMap { dict -> Repository? in /// compactMap으로 nil 제거 후 data추출
                    guard let id = dict["id"] as? Int,
                          let name = dict["name"] as? String,
                          let description = dict["description"] as? String,
                          let stargazersCount = dict["stargazers_count"] as? Int,
                          let language = dict["language"] as? String
                    else {
                        return nil
                    }
    
                    return Repository(
                        id: id,
                        name: name,
                        description: description,
                        stargazersCount: stargazersCount,
                        language: language
                    )
                }
            }
    }
    
}
