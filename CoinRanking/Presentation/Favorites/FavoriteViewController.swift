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
    
    @IBOutlet weak var tableviewFavorite: UITableView!
    let viewModel = FavoriteViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableviewFavorite.dataSource = self
        tableviewFavorite.delegate   = self
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchFavorites()
    }
    
    private func bindViewModel() {
        viewModel.reloadTable = { [weak self] in
            DispatchQueue.main.async {
                self?.tableviewFavorite.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource/Delegate
extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let fav = viewModel.favorites[indexPath.row]
//        if #available(iOS 16.0, *) {
//            return .init(configuration: .hostingConfiguration {
//                CoinRowView(
//                    coin: Coin(uuid: fav.uuid,
//                               symbol: "",
//                               name: fav.name,
//                               iconUrl: fav.image,
//                               marketCap: "",
//                               price: fav.price,
//                               t24hVolume: "",
//                               sparkline: fav.sparkline),
//                    isFavorite: true
//                )
//            })
//        } else {
            // fallback to UIHostingController
            let host = UIHostingController(rootView:
                CoinRowView(
                    number: indexPath.row + 1, coin: Coin(uuid: fav.uuid, symbol: "", name: fav.name, iconUrl: fav.image, marketCap: "", price: fav.price, t24hVolume: "", sparkline: fav.sparkline),
                    isFavorite: true
                )
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
       // }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Show detail
        let fav = viewModel.favorites[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVC.favoriteCoin = fav
        detailVC.isFromFav = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // Swipe to Unfavorite
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
         -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Unfavorite") { [weak self] _, _, done in
            guard let unFavUUID = self?.viewModel.favorites[indexPath.row].uuid else{
                return
            }
            self?.viewModel.unfavorite(uuid: unFavUUID)
            done(true)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
