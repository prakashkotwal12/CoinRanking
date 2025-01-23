//
//  CoinRowView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import SwiftUI
import SDWebImageSwiftUI

struct CoinRowView: View {
    let number : Int
    let coin: Coin
    let isFavorite: Bool
    
    var body: some View {
        HStack {
            WebImage(url: URL(string: coin.iconUrl))
                //.placeholder(Image(systemName: "photo"))
                .resizable()
                .frame(width: 38, height: 38)
            
            VStack(alignment: .leading) {
                Text("\(number)" + coin.name)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(coin.priceAsCurrency)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            if isFavorite {
                Image(systemName: "star.fill")
                    .foregroundColor(.orange)
            }
        }
        .padding()
        .background(Color("Secondary"))
        .cornerRadius(12)
    }
}

// Simple helper for formatting price
extension Coin {
    var priceAsCurrency: String {
        let priceDouble = Double(price) ?? 0
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: priceDouble as NSNumber) ?? price
    }
}
