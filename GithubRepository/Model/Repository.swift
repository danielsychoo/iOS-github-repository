//
//  Repository.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/08.
//

import RxDataSources


// MARK: - Codable

struct Repository: Codable, Equatable {
    
    let id: Int
    let name: String
    let description: String
    let stargazersCount: Int
    let language: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, language
        case stargazersCount = "stargazers_count"
    }
}

extension Repository: IdentifiableType {
    
    var identity: Int {
        return self.id
    }
}

// MARK: - SectionModel

struct RepositoryListSection: IdentifiableType {
    var items: [Item]
    var identity: String
}

extension RepositoryListSection: AnimatableSectionModelType {
    typealias Item = Repository

    init(original: RepositoryListSection, items: [Item]) {
        self = original
        self.items = items
    }
}
