//
//  PieChartView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI
import Charts

struct PieChartView: View {
    let dataPoints: [Double]
    
    var body: some View {
        Chart {
            ForEach(dataPoints.indices, id: \.self) { index in
                SectorMark(
                    angle: .value("Value", dataPoints[index])
                )
                .foregroundStyle(by: .value("Index", index))
            }
        }
    }    
}
