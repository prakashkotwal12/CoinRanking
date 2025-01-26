//
//  ChartViewUITests.swift
//  CoinRankingUITests
//
//  Created by Prakash Kotwal on 26/01/2025.
//

import Foundation
import XCTest
@testable import CoinRanking
import SwiftUI

final class ChartViewUITests: XCTestCase {
    var selectedChartType: TestChartType!
    var mockRenderer: MockChartRenderer!
    
    override func setUp() {
        super.setUp()
        selectedChartType = .line
        mockRenderer = MockChartRenderer()
    }
    
    override func tearDown() {
        selectedChartType = nil
        mockRenderer = nil
        super.tearDown()
    }
    
    func testLineChartRendering() {
        let dataPoints: [Double] = [10, 20, 30, 40, 50]
        let renderedView = mockRenderer.renderChart(data: dataPoints, type: .line)
        
        XCTAssertEqual(mockRenderer.calls.count, 1, "renderChart should be called once.")
        XCTAssertEqual(mockRenderer.calls.first?.type, .line, "The passed type should be '.line'.")
        XCTAssertEqual(mockRenderer.calls.first?.data, dataPoints, "The data points should match the input.")
        
        verifyViewRendering(renderedView)
    }
    
    func testBarChartRendering() {
        let dataPoints: [Double] = [15, 25, 35, 45, 55]
        let renderedView = mockRenderer.renderChart(data: dataPoints, type: .bar)
        
        XCTAssertEqual(mockRenderer.calls.count, 1, "renderChart should be called once.")
        XCTAssertEqual(mockRenderer.calls.first?.type, .bar, "The passed type should be '.bar'.")
        XCTAssertEqual(mockRenderer.calls.first?.data, dataPoints, "The data points should match the input.")
        
        verifyViewRendering(renderedView)
    }
    
    func testPieChartRendering() {
        let dataPoints: [Double] = [10, 30, 20, 40]
        let renderedView = mockRenderer.renderChart(data: dataPoints, type: .pie)
        
        XCTAssertEqual(mockRenderer.calls.count, 1, "renderChart should be called once.")
        XCTAssertEqual(mockRenderer.calls.first?.type, .pie, "The passed type should be '.pie'.")
        XCTAssertEqual(mockRenderer.calls.first?.data, dataPoints, "The data points should match the input.")
        
        verifyViewRendering(renderedView)
    }
    
    func testAreaChartRendering() {
        let dataPoints: [Double] = [50, 40, 30, 20, 10]
        let renderedView = mockRenderer.renderChart(data: dataPoints, type: .area)
        
        XCTAssertEqual(mockRenderer.calls.count, 1, "renderChart should be called once.")
        XCTAssertEqual(mockRenderer.calls.first?.type, .area, "The passed type should be '.area'.")
        XCTAssertEqual(mockRenderer.calls.first?.data, dataPoints, "The data points should match the input.")
        
        verifyViewRendering(renderedView)
    }
    
    func testPointChartRendering() {
        let dataPoints: [Double] = [5, 15, 25, 35, 45]
        let renderedView = mockRenderer.renderChart(data: dataPoints, type: .point)
        
        XCTAssertEqual(mockRenderer.calls.count, 1, "renderChart should be called once.")
        XCTAssertEqual(mockRenderer.calls.first?.type, .point, "The passed type should be '.point'.")
        XCTAssertEqual(mockRenderer.calls.first?.data, dataPoints, "The data points should match the input.")
        
        verifyViewRendering(renderedView)
    }
    
    // Helper function to validate rendering of the view
    private func verifyViewRendering(_ view: AnyView) {
        let hostingController = UIHostingController(rootView: view)
        // Embed in a UIWindow to ensure rendering.
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        XCTAssertNotNil(hostingController.view, "HostingController's view should not be nil.")
        
        hostingController.view.layoutIfNeeded()
        XCTAssertGreaterThan(hostingController.view.subviews.count, 0, "The rendered view should contain subviews.")
    }
    
    private func simulateButtonTap(for chartType: TestChartType, in hostingController: UIHostingController<ChartTypeFilterView>) {
        let button = findButton(withText: chartType.rawValue, in: hostingController.view)
        XCTAssertNotNil(button, "Button for \(chartType.rawValue) should exist.")
        button?.sendActions(for: .touchUpInside)
    }
    
    private func findButton(withText text: String, in view: UIView) -> UIButton? {
        for subview in view.subviews {
            if let button = subview as? UIButton,
               let title = button.title(for: .normal),
               title == text {
                return button
            }
            if let found = findButton(withText: text, in: subview) {
                return found
            }
        }
        return nil
    }
}
