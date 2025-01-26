//
//  CoinListsTableViewCell.swift
//  GetCoin
//
//  Created by Prakash Kotwal on 22/01/2025.
//

import UIKit
import SDWebImageSVGCoder

class CoinListsTableViewCell: UITableViewCell {
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelCoinName: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var imageFavorite: UIImageView!
    
    @IBOutlet weak var label24HourPerformance: UILabel!
    
    @IBOutlet weak var viewForwardArrow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewBackground.layer.cornerRadius = 12.0
        viewBackground.layer.masksToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageFavorite.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func updateCellUI(isFav : Bool, coin : CoinUIModel){
        
        if isFav{
            imageFavorite.isHidden = false
        }else{
            imageFavorite.isHidden = true
        }
        if let imageURL = coin.iconURL {
            setupImageView(imageIcon, with: imageURL.absoluteString)
        }
        
        if let change = Double(coin.change) {
            
            label24HourPerformance.text = String(format: "%.2f%%", change)
            label24HourPerformance.backgroundColor = change >= 0 ?         UIColor(hex: "#81C784")
            : UIColor(hex: "#F28B82")
            
        } else {
            label24HourPerformance.text = "N/A"
            label24HourPerformance.backgroundColor = .gray
            
        }
        label24HourPerformance.textColor = UIColor.white
        label24HourPerformance.layer.borderColor = UIColor(hex: coin.color ?? "")?.cgColor
        label24HourPerformance.layer.borderWidth = 2
        label24HourPerformance.layer.cornerRadius = 6
        label24HourPerformance.layer.masksToBounds = true
        labelCoinName.text = coin.name
        if let price = Double(coin.price) {
            let formatter = NumberFormatter()
            formatter.locale = Locale(identifier: "en_US")
            formatter.numberStyle = .currency
            
            if let formattedPrice = formatter.string(from: price as NSNumber) {
                labelPrice.text = formattedPrice
            } else {
                labelPrice.text = "N/A"
            }
        } else {
            labelPrice.text = "Invalid Price"
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    func setupImageView(_ imageView: UIImageView, with urlString: String) {
        let svgCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(svgCoder)
        
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1
        
        imageView.sd_setImage(with: URL(string: urlString),
                              placeholderImage: nil,
                              options: [.progressiveLoad, .retryFailed]) { image, error, cacheType, url in
            if let error = error {
                print("Failed to load image: \(error)")
            } else {
                //print("Image loaded successfully!")
            }
        }
    }    
}
