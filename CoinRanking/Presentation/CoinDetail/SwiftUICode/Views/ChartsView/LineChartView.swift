//
//  LineChartView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI
import Charts

struct LineChartView: View {
    let dataPoints: [Double]
    
    var body: some View {
        Chart {
            ForEach(dataPoints.indices, id: \.self) { index in
                LineMark(
                    x: .value("Time", index),
                    y: .value("Price", dataPoints[index])
                )
                .foregroundStyle(.blue)
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(position: .bottom)
        }
    }    
}
