//
//  OtherStatisticsView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI

struct OtherStatisticsView: View {
    let coin: CoinUIModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Other Statistics")
                .font(.headline)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Symbol:").bold()
                    Spacer()
                    Text(coin.symbol)
                }
                HStack {
                    Text("Rank:").bold()
                    Spacer()
                    Text("#\(coin.rank)")
                }
                HStack {
                    Text("24h Change:").bold()
                    Spacer()
                    Text("\(coin.change)%")
                }
                HStack {
                    Text("Market Cap:").bold()
                    Spacer()
                    Text("$\(coin.marketCap)")
                }
                HStack {
                    Text("BTC Price:").bold()
                    Spacer()
                    Text("\(coin.btcPrice) BTC")
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Contract Addresses:").bold()
                    ForEach(coin.contractAddresses, id: \.self) { address in
                        Text(address)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
