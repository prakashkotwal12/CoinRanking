//
//  FavoriteViewController.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import UIKit
import SwiftUI

final class FavoriteViewController: UIViewController {
    
    @IBOutlet weak var tableViewFavorite: UITableView!
    private let viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }
    
    private func setupTableView() {
        tableViewFavorite.dataSource = self
        tableViewFavorite.delegate = self
        tableViewFavorite.register(UINib(nibName: "CoinListsTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "CoinListsTableViewCell")
        tableViewFavorite.rowHeight = 84 // Consistent row height
    }
    
    private func bindViewModel() {
        viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.tableViewFavorite.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = viewModel.favorites[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CoinListsTableViewCell") as? CoinListsTableViewCell else {
            return UITableViewCell()
        }
        cell.updateCellUI(isFav: true, coin: coin)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.favorites[indexPath.row]
        pushToCoinDetailView(coin: coin)
    }
    
    private func pushToCoinDetailView(coin: Coin) {
        let coinDetailView = CoinDetailView(coinModel: coin)
        let hostingController = UIHostingController(rootView: coinDetailView)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    // Swipe to Unfavorite
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Unfavorite") { [weak self] _, _, done in
            guard let self = self else { return }
            let coinUUID = self.viewModel.favorites[indexPath.row].uuid
            self.viewModel.unfavorite(uuid: coinUUID)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
