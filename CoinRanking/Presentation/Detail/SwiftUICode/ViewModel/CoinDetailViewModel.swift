//
//  CoinDetailViewModel.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import Foundation
import SwiftUI

final class CoinDetailViewModel: ObservableObject {
    let coin: Coin
    
    @Published var filteredSparkline: [Double] = []
    @Published var selectedTimeFrame: String = "24h"
    @Published var selectedChartType: ChartType = .line
    
    private let timeFrames = ["24h", "7d", "30d"]
    
    init(coin: Coin) {
        self.coin = coin
        filterData(for: selectedTimeFrame)
    }
    
    var timeFrameOptions: [String] {
        timeFrames
    }
    
    func filterData(for timeFrame: String) {
        let sparkline = coin.sparkline.compactMap { Double($0 ?? "0") }
        switch timeFrame {
            case "24h":
                filteredSparkline = Array(sparkline.prefix(24))
            case "7d":
                filteredSparkline = Array(sparkline.prefix(7))
            case "30d":
                filteredSparkline = sparkline
            default:
                filteredSparkline = sparkline
        }
    }
}
