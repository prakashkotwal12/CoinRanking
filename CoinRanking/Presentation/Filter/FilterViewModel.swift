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
    var sortOrders: [SortOrder] {
        return SortOrder.allCases
    }
    
    var selectedFilter: FilterCategory = .name {
        didSet {
            onFilterSelectionChange?()
        }
    }
    var selectedSortOrder: SortOrder = .ascending {
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
