//
//  HomeViewModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation

final class HomeViewModel {
    private let repository: CoinRepositoryProtocol
    private(set) public var isLoading = false // Add this flag

    private(set) var coins: [Coin] = []
    private var originalCoins: [Coin] = []
    
    var reloadTable: (() -> Void)?  // closure to notify VC
    
    private var limit = 20
    private var offset = 0
    
    init(repository: CoinRepositoryProtocol = CoinRepository()) {
        self.repository = repository
    }
    
    
    func viewDidLoad() {
        fetchCoins()
    }
    
    func fetchCoins() {
        guard !isLoading else { return }
        repository.fetchCoins(limit: limit, offset: offset) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
                case .success(let list):
                    self.coins += list
                    self.originalCoins = self.coins
                    self.reloadTable?()
                case .failure(_):
                    break // handle error
            }
        }
    }
    
    func loadNextPage(completion: @escaping () -> Void) {
        guard !isLoading, limit < 100 else {
            completion()
            return
        }

        if limit < 100 {
            offset += 20
            limit += 20
            repository.fetchCoins(limit: limit, offset: offset) { [weak self] result in
                switch result {
                    case .success(let list):
                        guard let self = self else { return }
                        self.coins += list
                        self.originalCoins = self.coins
                        self.reloadTable?()
                        completion() // Notify completion
                    case .failure(_):
                        completion() // Notify completion even on failure
                }
            }
        } else {
            completion() // Notify completion if no more data to load
        }
    }
    
    func applyFilterHighestPrice() {
        coins.sort { (Double($0.price) ?? 0) > (Double($1.price) ?? 0) }
        reloadTable?()
    }
    
    func applyFilter24hPerf() {
        coins.sort { (Double($0.t24hVolume) ?? 0) > (Double($1.t24hVolume) ?? 0) }
        reloadTable?()
    }
    
    func resetFilter() {
        coins = originalCoins
        reloadTable?()
    }
    
    func favorite(coin: Coin) {
        repository.saveFavorite(coin)
        reloadTable?()
    }
    
    func isFavorite(uuid: String) -> Bool {
        return repository.isFavorite(uuid: uuid)
    }    
}
