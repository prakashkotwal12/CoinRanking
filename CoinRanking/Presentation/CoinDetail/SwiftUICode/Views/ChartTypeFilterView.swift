//
//  ChartTypeFilterView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI

struct ChartTypeFilterView: View {
    @Binding var selectedChartType: ChartType
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("Select Chart Type")
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            HStack {
                ForEach(ChartType.allCases, id: \.self) { chartType in
                    Button(action: {
                        selectedChartType = chartType
                    }) {
                        Text(chartType.rawValue)
                            .padding()
                            .background(selectedChartType == chartType ? Color.green : Color.gray.opacity(0.3))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                Spacer()
            }
        }
    }    
}
