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
    
    var repository: String?
    
    
    // MARK: - UI
    
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let starImageView = UIImageView()
    private let starLabel = UILabel()
    private let languageLabel = UILabel()
    
    
    // MARK: - LifeCycle
    
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
    }
    
}
