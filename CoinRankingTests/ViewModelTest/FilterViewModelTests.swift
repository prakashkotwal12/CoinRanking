//
//  FilterViewModelTests.swift
//  CoinRankingTests
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
import XCTest
@testable import CoinRanking

final class FilterViewModelTests: XCTestCase {
    var viewModel: FilterViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = FilterViewModel()
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testFilterCategories() {
        XCTAssertEqual(viewModel.filterCategories, FilterCategory.allCases, "Filter categories should match all cases in FilterCategory")
    }
    
    func testSortOrders() {
        XCTAssertEqual(viewModel.sortOrders, SortOrder.allCases, "Sort orders should match all cases in SortOrder")
    }
    
    func testDefaultSelectedFilter() {
        XCTAssertEqual(viewModel.selectedFilter, .name, "Default selected filter should be .name")
    }
    
    func testDefaultSelectedSortOrder() {
        XCTAssertEqual(viewModel.selectedSortOrder, .ascending, "Default selected sort order should be .ascending")
    }
    
    func testOnFilterSelectionChange() {
        let expectation = self.expectation(description: "Filter selection change callback should be triggered")
        
        viewModel.onFilterSelectionChange = {
            expectation.fulfill()
        }
        
        viewModel.selectedFilter = .name
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testOnSortOrderChange() {
        let expectation = self.expectation(description: "Sort order change callback should be triggered")
        
        viewModel.onSortOrderChange = {
            expectation.fulfill()
        }
        
        viewModel.selectedSortOrder = .descending
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testResetFilters() {
        viewModel.selectedFilter = .name
        viewModel.selectedSortOrder = .descending
        
        viewModel.resetFilters()
        
        XCTAssertEqual(viewModel.selectedFilter, .name, "Selected filter should reset to .name")
        XCTAssertEqual(viewModel.selectedSortOrder, .ascending, "Selected sort order should reset to .ascending")
    }
}
