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
    private let dataCount: Int  // used for reserving space for future data
    
    @State private var dragPosition: CGPoint = .zero
    @State private var dragPositionPrice: Double = -1
    @State private var showIndicator: Bool = false
    @State private var indicatorStirng: String = ""
    
    @State private var animateBlinkingCircle: Bool = false
    
    init(coin: CoinModel, prices: [[Double]]) {
        self.prices = prices
        self.data = prices.map{ $0[1] }
        self.dataCount = max(24 * 60 / 5, self.data.count - 1)
        self.coin = coin
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            priceStack
            indicatorBox
            // Figure Section
            GeometryReader { geometry in
                Group {
                    if data.count == 0 {
                        // Progress View
                        ProgressView().position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                    } else {
                        // baseline
                        Path.horizontalBaseLine(points: data, step: getStep(in: geometry), padding: padding, width: geometry.size.width)
                            .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                            .foregroundColor(.theme.secondaryText)
                        // stock price
                        Path.linePath(points: data, step: getStep(in: geometry), padding: padding)
                            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                        // blinking dot to indicate current price
                        getBlinkingDotView(in: geometry)
                        // Indicator
                        if showIndicator { getIndicatorLine(in: geometry) }
                    }
                }
                .contentShape(Rectangle())
                .rotationEffect(.degrees(180), anchor: .center)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                .gesture(getDragGesture(in: geometry))
            }
        }
    }
    
    private func getDragGesture(in geometry: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged({ value in
                guard data.count > 0 else { return }
                if !showIndicator { HapticManager.notification(type: .success) }
                showIndicator = true
                let returnedValue = getClosestDataPoint(to: value.location, in: geometry)
                dragPosition = returnedValue.point
                dragPositionPrice = returnedValue.value
                indicatorStirng = returnedValue.time
            })
            .onEnded({ _ in
                guard data.count > 0 else { return }
                showIndicator = false
                dragPosition = .zero
                indicatorStirng = ""
                HapticManager.notification(type: .success)
            })
    }
    
    private func getClosestDataPoint(to point: CGPoint, in geometry: GeometryProxy) -> (point: CGPoint, time: String, value: Double) {
        let step = getStep(in: geometry)
        let index = min(Int(round((point.x - padding.width / 2) / step.x)), data.count - 1)
        guard index >= 0 else { return (.zero, "", data.last ?? -1) }
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
    private var priceStack: some View {
        VStack(alignment: .leading, spacing: 10) {
            currentPrice
            priceChangeRow
        }
        .foregroundColor(.theme.accent)
        .padding(.horizontal)
    }
    
    private var currentPrice: some View {
        Group {
            if showIndicator {
                Text(dragPositionPrice.asCurrencyWith2Decimals())
            } else {
                Text((data.last ?? coin.currentPrice).asCurrencyWith2Decimals())
            }
        }
        .font(.largeTitle)
    }
    
    private var priceChangeRow: some View {
        HStack(spacing: 5) {
            Image(systemName: "triangle.fill")
                .font(.caption)
                .rotationEffect((subTitlePriceChange < 0 ? .degrees(180) : .degrees(0)), anchor: .center)
            Text(subTitlePriceChange.asCurrencyWith2Decimals())
            Text("(\(subTitlePriceChangePercent.asPercentString()))")
            if !showIndicator {
                Text("Today")
                    .foregroundColor(.theme.accent)
            }
        }
        .foregroundColor(subTitlePriceChange < 0 ? .theme.red: .theme.green)
        .font(.callout)
    }
    
    private func getBlinkingDotView(in geometry: GeometryProxy) -> some View {
        let step = getStep(in: geometry)
        let offset = data.min() ?? 0
        let index = data.count - 1
        return ZStack {
            Circle()
            Circle()
                .scale(animateBlinkingCircle ? 5.0 : 1.0)
                .opacity(animateBlinkingCircle ? 0.0 : 0.6)
                .onAppear {
                    withAnimation(repeatingAnimation) { animateBlinkingCircle = true }
                }
        }
        .foregroundColor(lineColor)
        .frame(width: 6, height: 6)
        .position(
            x: step.x * CGFloat(index) + padding.width / 2,
            y: CGFloat(data[index] - offset) * step.y + padding.height / 2
        )
    }
    
    private var indicatorBox: some View {
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
    }
    
    private func getIndicatorLine(in geometry: GeometryProxy) -> some View {
        Rectangle()
            .position(x: dragPosition.x, y: geometry.size.height/2)
            .frame(width: 1, height: geometry.size.height)
            .foregroundColor(.theme.secondaryText)
    }
    
    private var indicatorStringWidth: CGFloat { indicatorStirng.widthOfString(usingFont: UIFont.preferredFont(forTextStyle: .callout))}
    
    private var subTitlePriceChange: Double {
        guard let first = data.first, var last = data.last else { return 0 }
        if showIndicator { last = dragPositionPrice }
        return last - first
    }
    
    private var subTitlePriceChangePercent: Double {
        guard let first = data.first else { return 0 }
        return subTitlePriceChange / first * 100
    }
    
    private var lineColor: Color { (data.last ?? 0) - (data.first ?? 0) > 0 ? Color.theme.green : Color.theme.red }
    
    private var repeatingAnimation: Animation {
        Animation
            .easeOut(duration: 1)
            .repeatForever(autoreverses: false)
    }
    
    private func getStep(in geometry: GeometryProxy) -> CGPoint {
        var step = CGPoint(x: -1, y: -1)
        guard data.count > 1, let min = data.min(), let max = data.max() else { return step }
//        step.x = (geometry.size.width - padding.width) / CGFloat(data.count - 1)
        step.x = (geometry.size.width - padding.width) / CGFloat(dataCount)
        step.y = (geometry.size.height - padding.height) / CGFloat(max - min)
        return step
    }
    
    //    private var data: [Double] { coin.sparklineIn7D?.price ?? [] }
}
