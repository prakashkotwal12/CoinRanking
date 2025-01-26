//
//  BarChartView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI
import Charts

struct BarChartView: View {
    let dataPoints: [Double]
    
    var body: some View {
        Chart {
            ForEach(dataPoints.indices, id: \.self) { index in
                BarMark(
                    x: .value("Time", index),
                    y: .value("Price", dataPoints[index])
                )
                .foregroundStyle(.orange)
            }
        }
    }    
}
