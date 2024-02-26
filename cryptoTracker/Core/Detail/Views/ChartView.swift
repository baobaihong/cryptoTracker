//
//  ChartView.swift
//  cryptoTracker
//
//  Created by Jason on 2024/2/23.
//

import SwiftUI

struct ChartView: View {
    private let data: [Double]
    private let maxY: Double
    private let minY: Double
    private let lineColor: Color
    private let startingDate: Date
    private let endingDate: Date
    
    @State private var percentage: CGFloat = 0
    
    init(coin: CoinModel) {
        data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        
        let priceChange = (data.last ?? 0) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(dateString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)  // <- startingDate = endingDate-7day
    }
    
    var body: some View {
        VStack {
            chartView
                .frame(height: 200)
                .background(chartBackground)
                .overlay(alignment: .leading) { chartYAxis.padding(.horizontal, 4) }
            chartDateLabels
                .padding(.horizontal, 4)
        }
        .font(.caption)
        .foregroundStyle(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: DispatchWorkItem(block: {
                withAnimation(.linear(duration: 2)) {
                    percentage = 1.0
                }
            }))
        }
    }
}

extension ChartView {
    private var chartView: some View {
        GeometryReader { geometry in   // <- add Geometry to achieve dynamic chart width
            Path { path in
                for index in data.indices {
                    let xPosition = geometry.size.width / CGFloat(data.count) * CGFloat(index + 1)
                    
                    let yAxis = maxY - minY // <- calculate the range distance, e.g. 10000 = 60000 - 50000
                    let yPosition = (1 - CGFloat((data[index] - minY) / yAxis)) * geometry.size.height
                    // ↑ calculate the percentage away from the lowest price and multiply by the height
                    // ↑ since iOS cordinate system set (0, 0) at top left, we need to revert the chart
                    if index == 0 {
                        path.move(to: CGPoint(x: 0, y: 0)) // <- move to the original point
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition)) // <- draw the line
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2  , lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, y: 40)

        }
    }
    
    private var chartBackground: some View {
        VStack {
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
    }
    
    private var chartYAxis: some View {
        VStack {
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            let midPrice = ((maxY + minY) / 2).formattedWithAbbreviations()
            Text(midPrice)
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDateLabels: some View {
        HStack {
            Text(startingDate.asShortDateString())
            Spacer()
            Text(endingDate.asShortDateString())
        }
    }
}

#Preview {
    ChartView(coin: pd().coin)
}
