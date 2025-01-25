//
//  TimeFrameFilterView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 25/01/2025.
//

import SwiftUI

struct TimeFrameFilterView: View {
    @Binding var selectedTimeFrame: String
    let timeFrames: [String]
    let onSelect: (String) -> Void
    
    var body: some View {
        HStack {
            ForEach(timeFrames, id: \.self) { timeFrame in
                Button(action: {
                    selectedTimeFrame = timeFrame
                    onSelect(timeFrame)
                }) {
                    Text(timeFrame)
                        .padding()
                        .background(selectedTimeFrame == timeFrame ? Color.blue : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }
    }
}
