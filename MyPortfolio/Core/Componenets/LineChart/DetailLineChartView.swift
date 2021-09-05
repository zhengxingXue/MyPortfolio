//
//  DetailLineChartView.swift
//  DetailLineChartView
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import SwiftUI

struct DetailLineChartView: View {
    
    var coin: CoinModel
    var prices: [[Double]]
    private var data: [Double]
    
    @State private var dragPosition: CGPoint = .zero
    @State private var dragPositionPrice: Double = -1
    @State private var showIndicator: Bool = false
    @State private var indicatorStirng: String = ""
    
    init(coin: CoinModel, prices: [[Double]]) {
        self.coin = coin
        self.prices = prices
        self.data = prices.map{ $0[1] }
    }
    
    private var indicatorStringWidth: CGFloat { indicatorStirng.widthOfString(usingFont: UIFont.preferredFont(forTextStyle: .callout))}
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading, spacing: 10) {
                currentPrice
                priceChangeRow
            }
            .foregroundColor(.theme.accent)
            .padding(.horizontal)
            
            GeometryReader { geometry in
                HStack {
                    Rectangle()
                        .fill(Color.clear)
                        .overlay(
                            Text(indicatorStirng)
                                .foregroundColor(.theme.secondaryText),
                            alignment: .leading
                        )
                        .frame(width: indicatorStringWidth, height: 10)
                        .offset(x: min(max(padding.width / 2, dragPosition.x - indicatorStringWidth / 2), geometry.size.width - indicatorStringWidth - padding.width/2))
                }
                .font(.callout)
            }
            .frame(height: 10)
            
            // Line Section
            GeometryReader { geometry in
                Group {
                    // baseline
                    Path.horizontalBaseLine(points: data, step: getStep(in: geometry), padding: padding, width: geometry.size.width)
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundColor(.theme.secondaryText)
                    // stock price
                    Path.linePath(points: data, step: getStep(in: geometry), padding: padding)
                        .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    // Indicator
                    if showIndicator {
                        Rectangle()
                            .position(x: dragPosition.x, y: geometry.size.height/2)
                            .frame(width: 1, height: geometry.size.height)
                            .foregroundColor(.theme.secondaryText)
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            let returnedValue = getClosestDataPoint(to: value.location, in: geometry)
                            dragPosition = returnedValue.point
                            dragPositionPrice = returnedValue.value
                            showIndicator = true
                            indicatorStirng = returnedValue.time
                        })
                        .onEnded({ _ in
                            showIndicator = false
                            dragPosition = .zero
                            indicatorStirng = ""
                        })
                )
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            }
        }
    }
    
    private func getClosestDataPoint(to point: CGPoint, in geometry: GeometryProxy) -> (point: CGPoint, time: String, value: Double) {
        let step = getStep(in: geometry)
        let index = Int(round((point.x - padding.width / 2) / step.x))
        
        guard index >= 0 && index < data.count else { return (.zero, "", data.last ?? -1) }
        
        let point = CGPoint(
            x: step.x * CGFloat(index) + padding.width / 2,
            y: CGFloat(data[index] - data.min()!) * step.y + padding.height / 2
        )
        
        let timeString = Date(milliseconds: Int64(prices[index][0])).asDailyMarketChartString()
        
        return (point, timeString, data[index])
    }
    
    private let padding = CGSize(width: 20, height: 20)
}

struct DetailLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DetailLineChartView(coin: dev.coin, prices: dev.coinMarketChart.prices ?? [])
                    .frame(height: 500)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
            }
            .listStyle(.plain)
            .navigationTitle(dev.coin.name)
        }
    }
}

extension DetailLineChartView {
    private var currentPrice: some View {
        Group {
            if showIndicator {
                Text(dragPositionPrice.asCurrencyWith2Decimals())
            } else {
                Text((data.last ?? coin.currentPrice).asCurrencyWith2Decimals())
            }
        }
        .font(.title)
    }
    
    private var priceChangeRow: some View {
        HStack {
            Text(subTitle)
                .foregroundColor(subTitle.hasPrefix("-") ? .theme.red : .theme.green)
            if !showIndicator { Text("24 Hour") }
        }
        .font(.callout)
    }
    
    private var subTitle: String {
        guard let first = data.first, var last = data.last else { return "" }
        if showIndicator { last = dragPositionPrice }
        let change = last - first
        let sign = change < 0 ? "" : "+"
        let priceChange = abs(change) > 1 ? change.asCurrencyWith2Decimals() : change.asCurrencyWith6Decimals()
        let priceChangePercent = (change / first * 100).asPercentString()
        return "\(sign)\(priceChange)(\(sign)\(priceChangePercent))"
    }
    
    private var lineColor: Color { (data.last ?? 0) - (data.first ?? 0) > 0 ? Color.theme.green : Color.theme.red }
    
    private func getStep(in geometry: GeometryProxy) -> CGPoint {
        var step = CGPoint(x: 0, y: 0)
        guard data.count > 1, let min = data.min(), let max = data.max() else { return step }
        step.x = (geometry.size.width - padding.width) / CGFloat(data.count - 1)
        step.y = (geometry.size.height - padding.height) / CGFloat(max - min)
        return step
    }
    
    //    private var data: [Double] { coin.sparklineIn7D?.price ?? [] }
}
