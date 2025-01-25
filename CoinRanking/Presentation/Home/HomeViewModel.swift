//
//  HomeViewModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation

enum FilterCategory: String, CaseIterable {
    case price = "Price"
    case performance = "24h Performance"
    case name = "Name"
}

enum SortOrder: String, CaseIterable {
    case ascending = "Ascending"
    case descending = "Descending"
}

final class HomeViewModel {
    private let repository: CoinRepositoryProtocol
    private(set) public var isLoading = false
    
    private(set) var coins: [Coin] = []
    private var originalCoins: [Coin] = []
    private(set) var stats: Stats?
    
    private(set) var favoriteCoinIDs: Set<String> = []
    
    var reloadTable: (() -> Void)?
    
    var selectedFilter: FilterCategory = .name
    var selectedSortOrder: SortOrder = .ascending
    
    private var limit = 20
    private var offset = 0
    
    init(repository: CoinRepositoryProtocol = CoinRepository()) {
        self.repository = repository
        fetchFavoriteCoinIDs()
        NotificationCenter.default.addObserver(self, selector: #selector(handleFavoriteChange(_:)), name: .favoriteRemoved, object: nil)
    }
    
    func viewDidLoad() {
        fetchCoins()
    }
    
    func fetchCoins() {
        guard !isLoading else { return }
        isLoading = true
        repository.fetchCoins(limit: limit, offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
                case .success(let response):
                    self.coins += response.coins
                    self.stats = response.stats
                    self.originalCoins = self.coins.sorted { $0.name.lowercased() < $1.name.lowercased() }
                    self.coins = self.originalCoins
                    self.applyFavorites()
                    self.applyFilter()
                    self.reloadTable?()
                case .failure:
                    break
            }
        }
    }
    
    func applyFilter() {
        switch selectedFilter {
            case .price:
                coins.sort { (Double($0.price) ?? 0) > (Double($1.price) ?? 0) }
                if selectedSortOrder == .ascending {
                    coins.reverse()
                }
            case .performance:
                coins.sort { (Double($0.t24hVolume) ?? 0) > (Double($1.t24hVolume) ?? 0) }
                if selectedSortOrder == .ascending {
                    coins.reverse()
                }
            case .name:
                coins.sort { $0.name.lowercased() < $1.name.lowercased() }
                if selectedSortOrder == .descending {
                    coins.reverse()
                }
        }
        reloadTable?()
    }
    
    func resetFilter() {
        coins = originalCoins
        selectedFilter = .price
        selectedSortOrder = .ascending
        reloadTable?()
    }
    
    func favorite(coin: Coin) {
        repository.saveFavorite(coin)
        favoriteCoinIDs.insert(coin.uuid)
        applyFavorites()
        reloadTable?()
    }
    
    func unfavorite(uuid: String) {
        repository.removeFavorite(uuid: uuid)
        favoriteCoinIDs.remove(uuid)
        applyFavorites()
        reloadTable?()
    }
    
    func isFavorite(uuidString: String) -> Bool {
        return favoriteCoinIDs.contains(uuidString)
    }
    
    func loadNextPage(completion: @escaping () -> Void) {
        guard !isLoading, limit < 100 else {
            completion()
            return
        }
        
        offset += 20
        limit += 20
        repository.fetchCoins(limit: limit, offset: offset) { [weak self] result in
            guard let self = self else { return }
            switch result {
                case .success(let response):
                    self.coins += response.coins
                    self.stats = response.stats
                    self.originalCoins = self.coins
                    self.applyFavorites()
                    self.applyFilter()
                    self.reloadTable?()
                    completion()
                case .failure:
                    completion()
            }
        }
    }
    
    @objc private func handleFavoriteChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let removedUUID = userInfo["uuid"] as? String else { return }
        favoriteCoinIDs.remove(removedUUID)
        applyFavorites()
        reloadTable?()    
    }
    
    private func fetchFavoriteCoinIDs() {
        let favorites = repository.fetchFavorites()
        favoriteCoinIDs = Set(favorites.map { $0.uuid })
    }
    
    private func applyFavorites() {
        coins = coins.map { coin in
            var updatedCoin = coin
            updatedCoin.isFavorite = favoriteCoinIDs.contains(coin.uuid)
            return updatedCoin
        }
    }
}
