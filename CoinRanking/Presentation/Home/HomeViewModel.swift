//
//  HomeViewModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation

final class HomeViewModel {
    private let repository: CoinRepositoryProtocol
    private(set) public var isLoading = false
    
    private var domainCoins: [CoinDomainModel] = [] // Domain Models
    private(set) var uiCoins: [CoinUIModel] = []    // UI Models
    private var originalDomainCoins: [CoinDomainModel] = []
    private(set) var stats: StatsModel?
    
    private(set) var favoriteCoinIDs: Set<String> = []
    
    var reloadTable: (() -> Void)?
    
    var selectedFilter: FilterCategory = .name
    var selectedSortOrder: FilterOrder = .ascending
    
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
                    self.domainCoins += response.coins
                    self.stats = response.stats
                    self.originalDomainCoins = self.domainCoins.sorted { $0.name.lowercased() < $1.name.lowercased() }
                    self.domainCoins = self.originalDomainCoins
                    self.applyFavorites()
                    self.updateUICoins()
                    self.reloadTable?()
                case .failure(let apiError):
                    self.handleError(apiError)
            }
        }
    }
    
    private func handleError(_ error: APIError) {
        switch error {
            case .invalidURL:
                print("Error: Invalid response or URL from the server.")
            case .decodingError:
                print("Error: Unable to decode the response.")
            case .serverError(let error):
                print("Server Error: \(error)")
            case .unknownError(let error):
                print("Unknown Error: \(error)")
        }
    }
    
    func applyFilter() {
        switch selectedFilter {
            case .price:
                domainCoins.sort { (Double($0.price) ?? 0) > (Double($1.price) ?? 0) }
                if selectedSortOrder == .ascending {
                    domainCoins.reverse()
                }
            case .performance:
                domainCoins.sort { (Double($0.t24hVolume) ?? 0) > (Double($1.t24hVolume) ?? 0) }
                if selectedSortOrder == .ascending {
                    domainCoins.reverse()
                }
            case .name:
                domainCoins.sort { $0.name.lowercased() < $1.name.lowercased() }
                if selectedSortOrder == .descending {
                    domainCoins.reverse()
                }
        }
        updateUICoins()
        reloadTable?()
    }
    
    func resetFilter() {
        domainCoins = originalDomainCoins
        selectedFilter = .name
        selectedSortOrder = .ascending
        updateUICoins()
        reloadTable?()
    }
    
    func favorite(coin: CoinUIModel) {
        guard let domainCoin = domainCoins.first(where: { $0.uuid == coin.id }) else { return }
        repository.saveFavorite(domainCoin)
        favoriteCoinIDs.insert(domainCoin.uuid)
        applyFavorites()
        updateUICoins()
        reloadTable?()
    }
    
    func unfavorite(uuid: String) {
        repository.removeFavorite(uuid: uuid)
        favoriteCoinIDs.remove(uuid)
        applyFavorites()
        updateUICoins()
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
                    self.domainCoins += response.coins
                    self.stats = response.stats
                    self.originalDomainCoins = self.domainCoins
                    self.applyFavorites()
                    self.updateUICoins()
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
        updateUICoins()
        reloadTable?()
    }
    
    private func fetchFavoriteCoinIDs() {
        let favorites = repository.fetchFavorites()
        favoriteCoinIDs = Set(favorites.map { $0.uuid })
    }
    
    private func applyFavorites() {
        domainCoins = domainCoins.map { coin in
            var updatedCoin = coin
            updatedCoin.isFavorite = favoriteCoinIDs.contains(coin.uuid)
            return updatedCoin
        }
    }
    
    private func updateUICoins() {
        uiCoins = domainCoins.map { CoinUIModel(from: $0) }
    }    
}
