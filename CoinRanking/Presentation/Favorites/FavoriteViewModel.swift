//
//  FavoriteViewModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
final class FavoriteViewModel {
    private let repository: CoinRepositoryProtocol
    private(set) var favorites: [CoinUIModel] = []
    
    var reloadTable: (() -> Void)?
    
    init(repository: CoinRepositoryProtocol = CoinRepository()) {
        self.repository = repository
    }
    
    func fetchFavorites() {
        let domainFavorites = repository.fetchFavorites()
        favorites = domainFavorites.map { CoinUIModel(from: $0) }
        reloadTable?()
    }
    
    func unfavorite(uuid: String) {
        repository.removeFavorite(uuid: uuid)
        fetchFavorites()
        NotificationCenter.default.post(name: .favoriteRemoved, object: nil, userInfo: ["uuid" : uuid])
    }

}
