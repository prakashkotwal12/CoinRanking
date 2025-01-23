//
//  FilterView.swift
//  CoinRanking
//
//  Created by Prakash Kotwal on 23/01/2025.
//

import Foundation
import SwiftUI

struct FilterView: View {
    @Binding var selectedFilter: String
    var onFilter: () -> Void
    var onReset: () -> Void
    var onClose: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Sort By :")
                    .foregroundColor(.white)
                    .font(.headline)
                
                Picker("", selection: $selectedFilter) {
                    Text("Highest Price").tag("highestPrice")
                    Text("24 Hour Perf").tag("performance")
                }
                .pickerStyle(.segmented)
                .background(Color.white)
                
                HStack {
                    Button("Reset") {
                        onReset()
                    }
                    .frame(width: 100, height: 40)
                    .background(Color.white)
                    .foregroundColor(.pink)
                    .cornerRadius(20)
                    
                    Button("Filter") {
                        onFilter()
                    }
                    .frame(width: 100, height: 40)
                    .background(Color.pink)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                }
                
                Button {
                    onClose()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            .padding()
        }
    }    
}
