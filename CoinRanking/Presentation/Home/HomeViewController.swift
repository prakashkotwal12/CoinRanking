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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        bindViewModel()
        viewModel.viewDidLoad()
        
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
            }
        }
    }
    
    @IBAction func actionFilter(_ sender: Any) {
        // Present SwiftUI Filter
        showFilterSwiftUI()
    }
    
    private func showFilterSwiftUI() {
        var filterVC: UIHostingController<FilterView>?
        filterVC = UIHostingController(
            rootView: FilterView(
                selectedFilter: .constant("highestPrice"),
                onFilter: { [weak self] in
                    self?.viewModel.applyFilterHighestPrice()
                    filterVC?.dismiss(animated: true) // Use filterVC directly
                },
                onReset: { [weak self] in
                    self?.viewModel.resetFilter()
                    filterVC?.dismiss(animated: true) // Use filterVC directly
                },
                onClose: {
                    filterVC?.dismiss(animated: true) // Use filterVC directly
                }
            )
        )
        filterVC?.modalPresentationStyle = .overFullScreen
        present(filterVC!, animated: true)
    }
    
}

// MARK: - UITableViewDelegate/DataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coin = viewModel.coins[indexPath.row]
        
        // iOS16+ hosting configuration approach
//        if #available(iOS 16.0, *) {
//            return .init(configuration: .hostingConfiguration {
//                CoinRowView(coin: coin,
//                            isFavorite: self.viewModel.isFavorite(uuid: coin.uuid))
//            })
//        } else {
            // Fallback for older iOS
            let host = UIHostingController(rootView:
                                            CoinRowView(number: indexPath.row + 1, coin: coin,
                            isFavorite: self.viewModel.isFavorite(uuid: coin.uuid))
            )
            let cell = UITableViewCell()
            cell.contentView.addSubview(host.view)
            host.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                host.view.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                host.view.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                host.view.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor),
                host.view.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor),
            ])
            cell.selectionStyle = .none
            return cell
        //}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let coin = viewModel.coins[indexPath.row]
        // navigate to detail
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.coin = coin
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // Swipe to favorite
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
         -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Favorite") { [weak self] _, _, done in
            guard let coin = self?.viewModel.coins[indexPath.row] else { return }
            self?.viewModel.favorite(coin: coin)
            done(true)
        }
        action.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // Pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.coins.count - 1 { // last row
            guard !viewModel.isLoading else { return }
            showTableFooterLoader(true) // Show loader
            DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
                self.viewModel.loadNextPage { [weak self] in
                    DispatchQueue.main.async {
                        self?.showTableFooterLoader(false) // Hide loader once loading is done
                    }
                }
            }
        }
    }
    
//    if indexPath.row == viewModel.coins.count - 1 { // last row
//        showTableFooterLoader(true) // Show loader
//        viewModel.loadNextPage { [weak self] in
//            DispatchQueue.main.async {
//                self?.showTableFooterLoader(false) // Hide loader
//            }
//        }
//    }
    
    private func showTableFooterLoader(_ show: Bool) {
        if show {
            coinListTableView.tableFooterView?.isHidden = false
        } else {
            coinListTableView.tableFooterView?.isHidden = true
        }
    }
}
