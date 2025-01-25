//
//  AreaChartView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI
import Charts

struct AreaChartView: View {
    let dataPoints: [Double]

    var body: some View {
        Chart {
            ForEach(dataPoints.indices, id: \.self) { index in
                AreaMark(
                    x: .value("Time", index),
                    y: .value("Price", dataPoints[index])
                )
                .foregroundStyle(LinearGradient(colors: [.blue, .clear], startPoint: .top, endPoint: .bottom))
            }
        }
    }
}
