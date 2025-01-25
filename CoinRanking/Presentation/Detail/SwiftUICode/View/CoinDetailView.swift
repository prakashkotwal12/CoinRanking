//
//  CoinDetailView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI
import Charts
import SDWebImageSwiftUI

//struct CoinDetailView: View {
//    let coinModel: Coin
//
//    @State private var selectedTimeFrame: String = "24h"
//    @State private var filteredSparkline: [Double] = []
//    
//    private let timeFrames = ["24h", "7d", "30d"]
//
//    var body: some View {
//        VStack(spacing: 16) {
//            // Coin Name
//            Text(coinModel.name)
//                .font(.largeTitle)
//                .bold()
//                .padding(.top)
//
//            // Performance Chart/Graph
//            VStack {
//                Text("Performance Chart (\(selectedTimeFrame))")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                LineChartView(dataPoints: filteredSparkline)
//                    .frame(height: 200)
//                    .padding(.horizontal)
//            }
//
//            // Performance Filters
//            HStack {
//                ForEach(timeFrames, id: \.self) { timeFrame in
//                    Button(action: {
//                        self.selectedTimeFrame = timeFrame
//                        self.filterData(for: timeFrame)
//                    }) {
//                        Text(timeFrame)
//                            .padding()
//                            .background(selectedTimeFrame == timeFrame ? Color.blue : Color.gray.opacity(0.3))
//                            .foregroundColor(.white)
//                            .cornerRadius(8)
//                    }
//                }
//            }
//            .padding(.horizontal)
//
//            // Price
//            VStack {
//                Text("Price")
//                    .font(.headline)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                Text("$\(coinModel.price)")
//                    .font(.title2)
//                    .bold()
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.green.opacity(0.2))
//                    .cornerRadius(8)
//            }
//            .padding(.horizontal)
//
//            // Other Statistics
//            VStack(alignment: .leading, spacing: 8) {
//                Text("Statistics")
//                    .font(.headline)
//                HStack {
//                    Text("Market Cap:")
//                        .bold()
//                    Spacer()
//                    Text("$\(coinModel.marketCap)")
//                }
//                HStack {
//                    Text("Rank:")
//                        .bold()
//                    Spacer()
//                    Text("#\(coinModel.rank)")
//                }
//                HStack {
//                    Text("24h Volume:")
//                        .bold()
//                    Spacer()
//                    Text("$\(coinModel.t24hVolume)")
//                }
//            }
//            .padding()
//            .background(Color.gray.opacity(0.1))
//            .cornerRadius(8)
//            .padding(.horizontal)
//
//            Spacer()
//        }
//        .onAppear {
//            self.filterData(for: selectedTimeFrame)
//        }
//        .padding()
//    }
//
//    // Function to filter sparkline data based on time frame
//    private func filterData(for timeFrame: String) {
//        let sparkline = coinModel.sparkline.compactMap { Double($0 ?? "0") }
//        switch timeFrame {
//        case "24h":
//            filteredSparkline = Array(sparkline.prefix(24))
//        case "7d":
//            filteredSparkline = Array(sparkline.prefix(7))
//        case "30d":
//            filteredSparkline = sparkline
//        default:
//            filteredSparkline = sparkline
//        }
//    }
//}
//
struct CoinDetailView: View {
    @StateObject private var viewModel: CoinDetailViewModel
    private let chartRenderer: ChartRenderable = ChartRenderer()
    
    init(coinModel: Coin) {
        _viewModel = StateObject(wrappedValue: CoinDetailViewModel(coin: coinModel))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Name and Icon
                HStack(alignment: .top, spacing: 16) { // Reduced spacing between image and text
                    if let url = URL(string: viewModel.coin.iconUrl) {
                        WebImage(url: url)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 90, height: 90)
                            .clipShape(Circle()) // Make the image circular
                            .overlay(Circle().stroke(Color.white, lineWidth: 1)) // Add white border
                    }
                    VStack(alignment: .leading, spacing: 4) { // Reduced spacing between name and symbol
                        Text(viewModel.coin.name)
                            .font(.largeTitle)
                            .bold()
                            .multilineTextAlignment(.leading)
                        
                        Text(viewModel.coin.symbol)
                            .font(.subheadline)
                            .bold()
                            .multilineTextAlignment(.leading)
                            .padding(8) // Padding around the text
                            .background(
                                Color(UIColor(hex: viewModel.coin.color ?? "#ffffff") ?? .black) // Dynamic background color
                            )
                            .foregroundColor(.white) // Text color
                            .cornerRadius(4) // Rounded corners for the background
                            .overlay(
                                RoundedRectangle(cornerRadius: 4) // White border with rounded corners
                                    .stroke(Color.white, lineWidth: 1)
                            )
                    }
                    Spacer()
                }
                .padding(.top, 20) // Add gap from the top of the navigation controller
                .padding(.horizontal) // Horizontal padding for the entire HStack
            
                
                
                // Chart Type Selector
                ChartTypeFilterView(
                    selectedChartType: $viewModel.selectedChartType
                )
                .padding(.horizontal)
                
                // Render Chart
                VStack {
                    HStack(spacing: 8){
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
                
                //Price View
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
    let testCoin = Coin(
        uuid: "Qwsogvtv82FCd",
        symbol: "BTC",
        name: "Bitcoin",
        color: "#f7931A",
        iconUrl: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg",
        marketCap: "2072205580370",
        price: "104578.45062765518",
        t24hVolume: "35165002368",
        change: "-0.60",
        rank: 1,
        sparkline: ["105212.18460626443", "105376.37432118352", "105395.03018756177", "105246.88686613293"],
        listedAt: 1330214400,
        tier: 1,
        lowVolume: false,
        coinrankingUrl: "https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc",
        btcPrice: "1",
        contractAddresses: []
    )
    CoinDetailView(
        coinModel: testCoin
    )
}
