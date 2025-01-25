//
//  FilterVC.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import UIKit

protocol FilterDelegate {
    func applyFilter(filter: FilterCategory, sortOrder: SortOrder)
    func resetClicked()    
}

class FilterVC: UIViewController {
    
    @IBOutlet weak var tableViewFilterList: UITableView!
    @IBOutlet weak var buttonFilter: UIButton!
    @IBOutlet weak var buttonReset: UIButton!
    @IBOutlet weak var viewFilter: UIView!
    @IBOutlet weak var segmentSortOrder: UISegmentedControl!
    
    
    var viewModel = FilterViewModel()
    var delegateFilter: FilterDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    
    func setupUI() {
        viewFilter.layer.cornerRadius = 30
        viewFilter.layer.masksToBounds = true
        buttonFilter.layer.cornerRadius = 8
        buttonFilter.layer.masksToBounds = true
        
        segmentSortOrder.selectedSegmentIndex = viewModel.selectedSortOrder == .ascending ? 0 : 1
    }
    
    func setupBindings() {
        viewModel.onFilterSelectionChange = { [weak self] in
            self?.tableViewFilterList.reloadData()
        }
        
        viewModel.onSortOrderChange = { [weak self] in
            self?.segmentSortOrder.selectedSegmentIndex = self?.viewModel.selectedSortOrder == .ascending ? 0 : 1
        }
    }
    
    
    @IBAction func actionFilter(_ sender: Any) {
        delegateFilter?.applyFilter(filter: viewModel.selectedFilter, sortOrder: viewModel.selectedSortOrder)
        self.dismiss(animated: true)
    }
    
    @IBAction func actionReset(_ sender: Any) {
        viewModel.resetFilters()
        delegateFilter?.resetClicked()
        self.dismiss(animated: true)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionSortOrder(_ sender: Any) {
        viewModel.selectedSortOrder = segmentSortOrder.selectedSegmentIndex == 0 ? .ascending : .descending
        delegateFilter?.applyFilter(filter: viewModel.selectedFilter, sortOrder: viewModel.selectedSortOrder)
    }
}


extension FilterVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Filter By"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        let filter = viewModel.filterCategories[indexPath.row]
        
        cell.textLabel?.text = filter.rawValue
        cell.accessoryType = filter == viewModel.selectedFilter ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedFilter = viewModel.filterCategories[indexPath.row]
        delegateFilter?.applyFilter(filter: viewModel.selectedFilter, sortOrder: viewModel.selectedSortOrder)
    }
}
