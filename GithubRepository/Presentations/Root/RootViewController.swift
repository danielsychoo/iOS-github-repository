//
//  RootViewController.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/08.
//

import UIKit

import RxCocoa
import RxSwift
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
        $0.dataSource = self
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.RepositoryList
        self.title = self.organization + Text.navigationTitle
    }
    
    
    // MARK: - Methods
    
    @objc func didDragRefreshControl() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.fetchRepositories(of: self.organization)
        }
    }
    
    private func fetchRepositories(of organization: String) {
        Observable.from([organization])
            .map { organization -> URL in /// String to URL
                return URL(string: "https://api.github.com/orgs/\(organization)/repos")!
            }
            .map { url -> URLRequest in /// URL to URLRequest
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                return request
            }
            .flatMap { request -> Observable<(response: HTTPURLResponse, data: Data)> in
                return URLSession.shared.rx.response(request: request)
            }
            .filter { response, _ in /// responds ?? /// statusCode가 200~300 만 필터링
                return 200..<300 ~= response.statusCode
            }
            .map { _, data -> [[String: Any]] in
                guard let json = try? JSONSerialization.jsonObject(with: data), /// json 파싱
                      let resultArr = json as? [[String: Any]]
                else {
                    return []
                }
    
                return resultArr
            }
            .filter { resultArr in /// 값이 들어있는 것만 필터링
                // !resultArr.isEmpty
                resultArr.count > 0
            }
            .map { resultArr in
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
            .subscribe(onNext: { [weak self] newRepositories in /// 구독
                self?.repositories.onNext(newRepositories)
    
                DispatchQueue.main.async {
                    self?.RepositoryList.reloadData()
                    self?.RepositoryList.refreshControl?.endRefreshing() /// 새로고침 끝
                }
            })
            .disposed(by: disposeBag)
    }
    
}


// MARK: - UITableViewDataSource

extension RootViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        do { /// behaviorSubject에서 value 추출
            return try repositories.value().count
        } catch {
            print("error: \(error)")
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as? RepositoryListCell else { return UITableViewCell() }
        
        var currentRepository: Repository? {
            do {
                return try repositories.value()[indexPath.row]
            } catch {
                print("error: \(error)")
                return nil
            }
        }
        
        cell.repository = currentRepository
        
        return cell
    }
    
}
