
//  RootViewController.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/08.
//

import UIKit

import ReactorKit
import RxDataSources
import Then

class RootViewController: UIViewController, ReactorKit.View {
    private enum Text {
        static let navigationTitle = "Apple Repositories"
        static let refreshTitle = "당겨서 새로고침"
    }
    
    var disposeBag = DisposeBag()
    
    let refreshControl = UIRefreshControl().then {
        $0.backgroundColor = .white
        $0.tintColor = .darkGray
        $0.attributedTitle = NSAttributedString(string: Text.refreshTitle)
    }
    
    lazy var tableView = UITableView().then {
        $0.addSubview(self.refreshControl)
        $0.rowHeight = 140
        $0.register(RepositoryListCell.self, forCellReuseIdentifier: "RepositoryListCell")
    }
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<RepositoryListSection>(
        configureCell: { dataSource, tableView, indexPath, reactor -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "RepositoryListCell", for: indexPath) as! RepositoryListCell
            
            cell.repository = reactor
            
            return cell
        }
    )
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = self.tableView
        self.title = Text.navigationTitle
        
        self.reactor?.action.onNext(.update)
    }
    
    
    // MARK: - Bind
    
    func bind(reactor: RootViewReactor) {
        // Action (View -> Reactor)
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { _ in Reactor.Action.update }
            .do(onNext: { _ in self.refreshControl.endRefreshing() })
            .bind(to: reactor.action)
            .disposed(by: self.disposeBag)
        
        // State (Reactor -> View)
        reactor.state.map { $0.repositories }
            .map { [RepositoryListSection(items: $0, identity: "")] }
            .bind(to: self.tableView.rx.items(dataSource: self.dataSource))
            .disposed(by: disposeBag)
    }
}
