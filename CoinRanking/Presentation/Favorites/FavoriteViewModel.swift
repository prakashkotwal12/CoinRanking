//
//  FavoriteViewModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
final class FavoriteViewModel {
    private let repository: CoinRepositoryProtocol
    private(set) var favorites: [Coin] = []
    
    var reloadTable: (() -> Void)?
    
    init(repository: CoinRepositoryProtocol = CoinRepository()) {
        self.repository = repository
    }
    
    func fetchFavorites() {
        favorites = repository.fetchFavorites()
        reloadTable?()
    }
    
    func unfavorite(uuid: String) {
        repository.removeFavorite(uuid: uuid)
        fetchFavorites() // Refresh the list after removal
    }    
}
