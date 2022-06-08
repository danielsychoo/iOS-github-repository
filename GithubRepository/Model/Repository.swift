//
//  Repository.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/08.
//

// import Foundation

// MARK: - Codable

class Repository: Codable {
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
