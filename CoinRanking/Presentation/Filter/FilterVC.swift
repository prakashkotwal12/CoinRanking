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
    var delegateFilter: FilterDelegate?
    var selectedFilter: FilterCategory = .name
    var selectedSortOrder: SortOrder = .ascending
    
    private let filterCategories = FilterCategory.allCases
    private let sortOrders = SortOrder.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        viewFilter.layer.cornerRadius = 30
        viewFilter.layer.masksToBounds = true
        buttonFilter.layer.cornerRadius = 8
        buttonFilter.layer.masksToBounds = true
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        delegateFilter?.applyFilter(filter: selectedFilter, sortOrder: selectedSortOrder)
        self.dismiss(animated: true)
    }
    
    @IBAction func actionReset(_ sender: Any) {
        delegateFilter?.resetClicked()
        self.dismiss(animated: true)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func actionSortOrder(_ sender: Any) {
        selectedSortOrder = segmentSortOrder.selectedSegmentIndex == 0 ? .ascending : .descending
        delegateFilter?.applyFilter(filter: selectedFilter, sortOrder: selectedSortOrder)
    }
}

extension FilterVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCategories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Filter By"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath)
        
        let filter = filterCategories[indexPath.row]
        cell.textLabel?.text = filter.rawValue
        cell.accessoryType = filter == selectedFilter ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFilter = filterCategories[indexPath.row]
        delegateFilter?.applyFilter(filter: selectedFilter, sortOrder: selectedSortOrder)
        tableView.reloadData()
    }
}
