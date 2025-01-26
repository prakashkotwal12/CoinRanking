//
//  FilterViewModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import Foundation
final class FilterViewModel {
    var filterCategories: [FilterCategory] {
        return FilterCategory.allCases
    }
    var sortOrders: [FilterOrder] {
        return FilterOrder.allCases
    }
    
    var selectedFilter: FilterCategory = .name {
        didSet {
            onFilterSelectionChange?()
        }
    }
    var selectedSortOrder: FilterOrder = .ascending {
        didSet {
            onSortOrderChange?()
        }
    }
    
    var onFilterSelectionChange: (() -> Void)?
    var onSortOrderChange: (() -> Void)?
    
    func resetFilters() {
        selectedFilter = .name
        selectedSortOrder = .ascending
    }
}
