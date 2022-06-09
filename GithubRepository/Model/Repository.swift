//
//  Repository.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/08.
//

import RxDataSources


// MARK: - Codable

struct Repository: Codable {
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


// MARK: - SectionModel

struct RepositorySection {
    var items: [Item]
}

extension RepositorySection: SectionModelType {
    typealias Item = Repository

    init(original: RepositorySection, items: [Item]) {
        self = original
        self.items = items
    }
}
