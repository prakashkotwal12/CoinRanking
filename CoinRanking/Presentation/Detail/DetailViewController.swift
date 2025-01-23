//
//  DetailViewController.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import UIKit
import SDWebImage

final class DetailViewController: UIViewController {
    @IBOutlet weak var coinIcon: UIImageView!
    @IBOutlet weak var coinName: UILabel!
    @IBOutlet weak var coinPrice: UILabel!
    
    var coin: Coin?
    var favoriteCoin: FavCoins?
    var isFromFav = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Chart logic remains the same...
    }
    
    private func updateUI() {
        if isFromFav, let fav = favoriteCoin {
            coinIcon.sd_setImage(with: URL(string: fav.image))
            coinName.text = fav.name
            coinPrice.text = Coin(uuid: fav.uuid, symbol: "", name: fav.name, iconUrl: fav.image, marketCap: "", price: fav.price, t24hVolume: "", sparkline: fav.sparkline).priceAsCurrency
        } else if let coin = coin {
            coinIcon.sd_setImage(with: URL(string: coin.iconUrl))
            coinName.text = coin.name
            coinPrice.text = coin.priceAsCurrency
        }
    }
}
