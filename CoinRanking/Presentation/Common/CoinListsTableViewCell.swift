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
        // Initialization code
        viewBackground.layer.cornerRadius = 12.0
        viewBackground.layer.masksToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        imageFavorite.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func updateCellUI(isFav : Bool, coin : Coin){

        if isFav{
            imageFavorite.isHidden = false
        }else{
            imageFavorite.isHidden = true
        }
        setupImageView(imageIcon, with: coin.iconUrl)
        
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
        let price = Double(coin.price)
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        
        if let formattedTipAmount = formatter.string(from: price! as NSNumber) {
            labelPrice.text = "\(formattedTipAmount)" //+ "     " + coin.t24hVolume
        }
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }

    func setupImageView(_ imageView: UIImageView, with urlString: String) {
        // Register SVG coder to handle SVG images
        let svgCoder = SDImageSVGCoder.shared
        SDImageCodersManager.shared.addCoder(svgCoder)

        // Apply corner radius and clipping for circular or rounded image
        imageView.layer.cornerRadius = imageView.frame.size.width / 2 // Circular shape
        imageView.layer.masksToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 1

        // Set the image with progressive loading
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

extension UIView{
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius

        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
      }
}
