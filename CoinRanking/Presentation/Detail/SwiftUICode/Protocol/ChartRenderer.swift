//
//  ChartRenderer.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI
import Charts

protocol ChartRenderable {
    func renderChart(data: [Double], type: ChartType) -> AnyView
}

struct ChartRenderer: ChartRenderable {
    func renderChart(data: [Double], type: ChartType) -> AnyView {
        switch type {
            case .line:
                return AnyView(LineChartView(dataPoints: data))
            case .bar:
                return AnyView(BarChartView(dataPoints: data))
            case .pie:
                return AnyView(PieChartView(dataPoints: data))
            case .area:
                return AnyView(AreaChartView(dataPoints: data))
            case .point:
                return AnyView(PointChartView(dataPoints: data))
        }
    }
}
