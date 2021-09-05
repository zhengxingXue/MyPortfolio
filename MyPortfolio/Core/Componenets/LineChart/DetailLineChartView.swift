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
    
    init(coin: CoinModel, prices: [[Double]]) {
        self.coin = coin
        self.prices = prices
    }
    
    private var data: [Double] { prices.map{ $0[1] } }
    
    private let padding = CGSize(width: 0, height: 20)
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                currentPrice
                
                HStack {
                    Text(subTitle)
                        .foregroundColor((coin.priceChange24H ?? 0) < 0 ? .theme.red : .theme.green)
                    Text("24 Hour")
                }
                .font(.callout)
            }
            .foregroundColor(.theme.accent)
            .padding(.horizontal)
            
            GeometryReader { geometry in
                // baseline
                Path.horizontalBaseLine(points: data, step: getStep(in: geometry), padding: padding, width: geometry.size.width)
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .foregroundColor(.theme.secondaryText)
                // stock price
                Path.linePath(points: data, step: getStep(in: geometry), padding: padding)
                    .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            }
            .rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
    }
    
}

struct DetailLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        DetailLineChartView(coin: dev.coin, prices: dev.coinMarketChart.prices ?? [])
            .frame(height: 500)
    }
}

extension DetailLineChartView {
    private var currentPrice: some View {
        Text((data.last ?? coin.currentPrice).asCurrencyWith2Decimals())
            .font(.title)
    }
    
    private var subTitle: String {
        let change = coin.priceChange24H ?? 0
        let sign = change < 0 ? "" : "+"
        let priceChange = abs(change) > 1 ? change.asCurrencyWith2Decimals() : change.asCurrencyWith6Decimals()
        let priceChangePercent = coin.priceChangePercentage24H?.asPercentString() ?? ""
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
