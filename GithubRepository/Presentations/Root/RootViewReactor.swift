//
//  RootViewReactor.swift
//  GithubRepository
//
//  Created by sungyeopTW on 2022/06/10.
//

import ReactorKit

final class RootViewReactor: Reactor {
    
    var disposeBag = DisposeBag()
    
    
    // MARK: - Enum & State
    
    enum Action {
        case update
    }
    
    enum Mutation {
        case setRepositories([Repository])
        case setLoading(Bool)
    }
    
    struct State {
        var repositories: [Repository]
        var isLoading: Bool
    }
    
    var initialState: State = .init(
        repositories: [],
        isLoading: false
    )
    
    
    // MARK: - Mutate
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .update:
            return .concat([
                .just(.setLoading(true)),
                self.fetch().map { .setRepositories($0) },
                .just(.setLoading(false))
            ])
        }
    }
    
    
    // MARK: - Reduce
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .setRepositories(let repositories):
            newState.repositories = repositories.shuffled()
        case .setLoading(let isLoading):
            newState.isLoading = isLoading
        }
        
        return newState
    }
    
    
    // MARK: - Methods
    
    private func fetch() -> Observable<[Repository]> {
        guard let url = URL(string: "https://api.github.com/orgs/Apple/repos") else { return .empty() }
    
        return URLSession.shared.rx.response(request: URLRequest(url: url))
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
