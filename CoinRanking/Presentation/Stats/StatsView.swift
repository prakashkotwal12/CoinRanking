//
//  StatsView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI

struct StatsView: View {
    let stats: StatsModel
    @State private var offsetX: CGFloat = 0
    @State private var isPaused: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "chart.bar")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.white)
                .padding(.leading, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    Text("Market Statistics:")
                        .font(.headline)
                        .bold()
                    Text("Total: \(stats.total)")
                    Text("Total Coins: \(stats.totalCoins)")
                    Text("Total Markets: \(stats.totalMarkets)")
                    Text("Total Exchanges: \(stats.totalExchanges)")
                    Text("Market Cap: $\(stats.totalMarketCap)B")
                    Text("24h Volume: $\(stats.total24hVolume)B")
                }
                .font(.subheadline)
                .foregroundColor(.primary)
                .offset(x: offsetX)
                .lineLimit(1)
            }
            .frame(height: 50)
            .allowsHitTesting(false)
        }
        .cornerRadius(8)
        .padding(.horizontal)
        .onTapGesture {
            pauseAnimation()
        }
        .onAppear {
            startAnimation()
        }
    }
    
    private func startAnimation() {
        withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
            offsetX = -UIScreen.main.bounds.width
        }
    }
    
    private func pauseAnimation() {
        isPaused = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isPaused = false
            withAnimation(.linear(duration: 15).repeatForever(autoreverses: false)) {
                offsetX = -UIScreen.main.bounds.width
            }
        }
    }
}
