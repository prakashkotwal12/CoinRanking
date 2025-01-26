//
//  MockChartRenderer.swift
//  CoinRankingUITests
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
@testable import CoinRanking
import SwiftUI

final class MockChartRenderer: TestChartRenderable {
    private(set) var calls: [(data: [Double], type: TestChartType)] = []
    
    func renderChart(data: [Double], type: TestChartType) -> AnyView {
        calls.append((data, type))
        return AnyView(Text("Mock Chart for \(type.rawValue)"))
    }
    
    func clearCalls() {
        calls.removeAll()
    }    
}


public enum TestChartType: String, CaseIterable {
    case line = "Line"
    case bar = "Bar"
    case pie = "Pie"
    case area = "Area"
    case point = "Point"
}

protocol TestChartRenderable {
    func renderChart(data: [Double], type: TestChartType) -> AnyView
}
