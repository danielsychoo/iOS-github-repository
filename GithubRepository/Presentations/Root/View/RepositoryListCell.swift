//
//  RepositoryListCell.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/08.
//

import UIKit

import SnapKit
import Then

class RepositoryListCell: UITableViewCell {
    
    var repository: Repository?
    
    
    // MARK: - UI
    
    private lazy var nameLabel = UILabel().then {
        $0.text = self.repository?.name
        $0.font = .systemFont(ofSize: 15.0, weight: .bold)
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = self.repository?.description
        $0.font = .systemFont(ofSize: 15.0)
        $0.numberOfLines = 2
    }
    
    private var starImageView = UIImageView().then {
        $0.image = UIImage(systemName: "star")
    }
    
    private lazy var starLabel = UILabel().then {
        $0.text = String(self.repository?.stargazersCount ?? 0)
        $0.font = .systemFont(ofSize: 16.0)
        $0.textColor = .gray
    }
    
    private lazy var languageLabel = UILabel().then {
        $0.text = self.repository?.language
        $0.font = .systemFont(ofSize: 16.0)
        $0.textColor = .gray
    }
    
    
    // MARK: - LifeCycle
    
    // override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    //     super.init(style: style, reuseIdentifier: reuseIdentifier)
    //
    //     self.setupConstraints()
    // }
    //
    // required init?(coder: NSCoder) {
    //     fatalError("init(coder:) has not been implemented")
    // }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        self.setupConstraints()
    }
    
}


// MARK: - Layout

extension RepositoryListCell {
    
    private func setupConstraints() {
        let subViews = [
            self.nameLabel,
            self.descriptionLabel,
            self.starImageView,
            self.starLabel,
            self.languageLabel
        ]
        subViews.forEach { self.contentView.addSubview($0) }
        
        self.nameLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(18)
        }
        
        self.descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(self.nameLabel.snp.bottom).offset(3)
            $0.leading.trailing.equalTo(self.nameLabel)
        }
        
        self.starImageView.snp.makeConstraints {
            $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(8)
            $0.leading.equalTo(self.descriptionLabel)
            $0.width.height.equalTo(20)
            $0.bottom.equalToSuperview().inset(18)
        }
        
        self.starLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.starImageView)
            $0.leading.equalTo(self.starImageView.snp.trailing).offset(5)
        }
        
        self.languageLabel.snp.makeConstraints {
            $0.centerY.equalTo(self.starLabel)
            $0.leading.equalTo(self.starLabel.snp.trailing).offset(12)
        }
    }
    
}
