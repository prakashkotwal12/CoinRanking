//
//  CoinDetailView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI
import Charts
import SDWebImageSwiftUI

struct CoinDetailView: View {
    @StateObject private var viewModel: CoinDetailViewModel
    private let chartRenderer: ChartRenderable = ChartRenderer()
    
    init(coinModel: CoinUIModel) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coinModel))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Name and Icon
                HStack(alignment: .top, spacing: 16) {
                    if let url = viewModel.coin.iconURL {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.coin.name)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.leading)
                        
                        Text(viewModel.coin.symbol)
                            .font(.subheadline)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .padding(8)
                            .background(
                                Color(UIColor(hex: viewModel.coin.color ?? "#ffffff") ?? .black)
                            )
                            .foregroundColor(.white)
                            .cornerRadius(4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                    Spacer()
                }
                .padding(.top, 20)
                .padding(.horizontal)
                
                // Chart Type Selector
                ChartTypeFilterView(
                    selectedChartType: $viewModel.selectedChartType
                )
                .padding(.horizontal)
                
                // Render Chart
                VStack {
                    HStack(spacing: 8) {
                        Text("Performance Chart (\(viewModel.selectedTimeFrame))")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                    }
                    .padding(.leading, 8)
                    
                    chartRenderer.renderChart(
                        data: viewModel.filteredSparkline,
                        type: viewModel.selectedChartType
                    )
                    .frame(height: 300)
                    .padding(.horizontal)
                }
                
                // Time Frame Filters
                TimeFrameFilterView(
                    selectedTimeFrame: $viewModel.selectedTimeFrame,
                    timeFrames: viewModel.timeFrameOptions,
                    onSelect: viewModel.filterData(for:)
                )
                .padding(.horizontal)
                
                // Price View
                VStack {
                    Text("Price")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("$\(viewModel.coin.price)")
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                
                // Other Statistics
                OtherStatisticsView(coin: viewModel.coin)
                    .padding(.horizontal)
                
                Spacer()
            }
        }
    }    
}

#Preview {
    let testCoin = CoinUIModel(
        id: "Qwsogvtv82FCd",
        symbol: "BTC",
        name: "Bitcoin",
        color: "#f7931A",
        iconURL: URL(string: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg"),
        marketCap: "2072205580370",
        price: "104578.45062765518",
        volume24h: "35165002368",
        change: "-0.60",
        changePercentage: "-0.60",
        rank: 1,
        sparkline: ["105212.18460626443", "105376.37432118352", "105395.03018756177", "105246.88686613293"],
        listedAt: "Jan 1, 2012",
        tier: "Tier 1",
        lowVolume: false,
        coinRankingURL: URL(string: "https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc"),
        btcPrice: "1",
        contractAddresses: [],
        isFavorite: false
    )
    CoinDetailView(
        coinModel: testCoin
    )
}
