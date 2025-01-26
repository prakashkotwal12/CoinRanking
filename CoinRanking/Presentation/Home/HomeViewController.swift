//
//  HomeViewController.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import UIKit
import SwiftUI

final class HomeViewController: UIViewController {
    
    @IBOutlet weak var coinListTableView: UITableView!
    let viewModel = HomeViewModel()
    
    @IBOutlet weak var viewStats: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        self.title = "Coin List"
        setupTableView()
        bindViewModel()
        
        coinListTableView.register(UINib(nibName: "CoinListsTableViewCell", bundle: nil), forCellReuseIdentifier: "CoinListsTableViewCell")
        
        
        setupTableFooterView()
    }
    
    private func setupTableFooterView() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: coinListTableView.frame.size.width, height: 50))
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        footerView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: footerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: footerView.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
        coinListTableView.tableFooterView = footerView
    }
    
    private func setupTableView() {
        coinListTableView.delegate = self
        coinListTableView.dataSource = self
    }
    
    private func bindViewModel() {
        viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.coinListTableView.reloadData()
                self?.updateStatsView()
            }
        }
    }
    private func updateStatsView() {
        guard let stats = viewModel.stats else { return }
        
        let statsView = StatsView(stats: stats)
        let hostingController = UIHostingController(rootView: statsView)
        
        addChild(hostingController)
        viewStats.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: viewStats.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: viewStats.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: viewStats.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: viewStats.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        self.performSegue(withIdentifier: "segueFilter", sender: self)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "segueFilter") {
            let filterVC = segue.destination as! FilterVC
            filterVC.viewModel.selectedFilter = viewModel.selectedFilter
            filterVC.viewModel.selectedSortOrder = viewModel.selectedSortOrder
            filterVC.delegateFilter = self
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.uiCoins.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = viewModel.uiCoins[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinListsTableViewCell") as? CoinListsTableViewCell else {
            fatalError("Failed to dequeue CoinListsTableViewCell")
        }
        cell.updateCellUI(isFav: coin.isFavorite, coin: coin)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.uiCoins[indexPath.row]
        self.pushToCoinDetailView(coin: coin)
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let coin = viewModel.uiCoins[indexPath.row]
        let isFavorite = coin.isFavorite
        let action = UIContextualAction(style: .normal, title: isFavorite ? "Unfavorite" : "Favorite") { [weak self] _, _, done in
            guard let self = self else { return }
            
            if isFavorite {
                self.viewModel.unfavorite(uuid: coin.id)
            } else {
                self.viewModel.favorite(coin: coin)
            }
            done(true)
        }
        action.backgroundColor = isFavorite ? .gray : .blue
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.uiCoins.count - 1 {
            guard !viewModel.isLoading else { return }
            showTableFooterLoader(true)
            //Adjust the loader display time by setting the duration in seconds. Increase the value to show the loader for a longer period.
            let timerToLoad = 0.1
            DispatchQueue.main.asyncAfter(deadline: .now() + timerToLoad) {
                self.viewModel.loadNextPage { [weak self] in
                    DispatchQueue.main.async {
                        self?.showTableFooterLoader(false)
                    }
                }
            }
        }
    }
    
    private func showTableFooterLoader(_ show: Bool) {
        if show {
            coinListTableView.tableFooterView?.isHidden = false
        } else {
            coinListTableView.tableFooterView?.isHidden = true
        }
    }
    
    private func pushToCoinDetailView(coin: CoinUIModel) {
        let coinDetailView = CoinDetailView(coinModel: coin)
        let hostingController = UIHostingController(rootView: coinDetailView)
        self.navigationController?.pushViewController(hostingController, animated: true)
    }
}

extension HomeViewController: FilterDelegate {
    func applyFilter(filter: FilterCategory, sortOrder: FilterOrder) {
        viewModel.selectedFilter = filter
        viewModel.selectedSortOrder = sortOrder
        viewModel.applyFilter()
    }
    
    func resetClicked() {
        viewModel.resetFilter()
    }
}
