//
//  HomeViewModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation

//enum FilterType {
//    case nameAscending
//    case nameDescending
//    case highestPrice
//    case lowestPrice
//    case performanceAscending
//    case performanceDescending
//}
//
//final class HomeViewModel {
//    private let repository: CoinRepositoryProtocol
//    private(set) public var isLoading = false // Add this flag
//    
//    private(set) var coins: [Coin] = []
//    private var originalCoins: [Coin] = []
//    private(set) var stats: Stats?
//    
//    var reloadTable: (() -> Void)?  // closure to notify VC
//    
//    private var limit = 20
//    private var offset = 0
//    
//    init(repository: CoinRepositoryProtocol = CoinRepository()) {
//        self.repository = repository
//    }
//    
//    
//    func viewDidLoad() {
//        fetchCoins()
//    }
//    
//    func fetchCoins() {
//        guard !isLoading else { return }
//        repository.fetchCoins(limit: limit, offset: offset) { [weak self] result in
//            guard let self = self else { return }
//            self.isLoading = false
//            switch result {
//                case .success(let response):
//                    self.coins += response.coins
//                    self.stats = response.stats
//                    self.originalCoins = self.coins
//                    self.reloadTable?()
//                case .failure(_):
//                    break // handle error
//            }
//        }
//    }
//    
//    func loadNextPage(completion: @escaping () -> Void) {
//        guard !isLoading, limit < 100 else {
//            completion()
//            return
//        }
//        
//        if limit < 100 {
//            offset += 20
//            limit += 20
//            repository.fetchCoins(limit: limit, offset: offset) { [weak self] result in
//                switch result {
//                    case .success(let response):
//                        guard let self = self else { return }
//                        self.coins += response.coins
//                        self.stats = response.stats
//                        self.originalCoins = self.coins
//                        self.reloadTable?()
//                        completion() // Notify completion
//                    case .failure(_):
//                        completion() // Notify completion even on failure
//                }
//            }
//        } else {
//            completion() // Notify completion if no more data to load
//        }
//    }
//    
//    func applyFilterHighestPrice() {
//        coins.sort { (Double($0.price) ?? 0) > (Double($1.price) ?? 0) }
//        reloadTable?()
//    }
//    
//    func applyFilter24hPerf() {
//        coins.sort { (Double($0.t24hVolume) ?? 0) > (Double($1.t24hVolume) ?? 0) }
//        reloadTable?()
//    }
//    
//    func resetFilter() {
//        coins = originalCoins
//        reloadTable?()
//    }
//    
//    func favorite(coin: Coin) {
//        repository.saveFavorite(coin)
//        reloadTable?()
//    }
//    
//    func isFavorite(uuidString: String) -> Bool {
//        //        guard let uuid = UUID(uuidString: uuidString) else{
//        //            return false
//        //        }
//        return repository.isFavorite(uuid: uuidString)
//    }
//    
//    func applyFilter(filterData: String = "") {
//        //        highestPrice    "performance
//        switch filterData {
//            case "highestPrice":
//                coins = coins.sorted { (Double($0.price) ?? 0) > (Double($1.price) ?? 0) }
//            case "performance":
//                coins = coins.sorted { (Double($0.t24hVolume) ?? 0) > (Double($1.t24hVolume) ?? 0) }
//            default:
//                coins = coins.sorted { ($0.name) > ($1.name) }
//        }
//        reloadTable?()
//    }
//}
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
    
    var reloadTable: (() -> Void)?  // Closure to notify VC
    
    var selectedFilter: FilterCategory = .name
    var selectedSortOrder: SortOrder = .ascending
    
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
                    self.applyFilter()
                    self.reloadTable?()
                case .failure:
                    break // Handle error if needed
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
        reloadTable?()
    }
    
    func isFavorite(uuidString: String) -> Bool {
        return repository.isFavorite(uuid: uuidString)
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
                    case .success(let response):
                        guard let self = self else { return }
                        self.coins += response.coins
                        self.stats = response.stats
                        self.originalCoins = self.coins
                        self.applyFilter()
                        self.reloadTable?()
                        completion()
                    case .failure(_):
                        completion()
                }
            }
        } else {
            completion()
        }
    }    
}
