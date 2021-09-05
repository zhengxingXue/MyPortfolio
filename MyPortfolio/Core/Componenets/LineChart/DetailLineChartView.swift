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
    
    private var data: [Double] { prices.map{ $0[1] } }
    
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
            
            SimpleLineChartView(data: data, lineWidth: 2, padding: CGSize(width: 10, height: 20))
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
    
//    private var data: [Double] { coin.sparklineIn7D?.price ?? [] }
}
