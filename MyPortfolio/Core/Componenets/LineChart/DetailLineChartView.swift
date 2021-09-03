//
//  DetailLineChartView.swift
//  DetailLineChartView
//
//  Created by Jim's MacBook Pro on 9/3/21.
//

import SwiftUI

struct DetailLineChartView: View {
    
    var coin: CoinModel
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(coin.currentPrice.asCurrencyWith6Decimals())
                    .font(.title)
                    .foregroundColor(.theme.accent)
                HStack {
                    Text(subTitle)
                        .foregroundColor((coin.priceChange24H ?? 0) < 0 ? .theme.red : .theme.green)
                    Text("Today")
                        .foregroundColor(.theme.accent)
                }
                .font(.callout)
            }
            .padding(.horizontal)
            
            SimpleLineChartView(data: data, lineWidth: 2, padding: CGSize(width: 10, height: 20))
        }
    }
    
    private var data: [Double] { coin.sparklineIn7D?.price ?? [] }
    private var subTitle: String {
        let change = coin.priceChange24H ?? 0
        let sign = change < 0 ? "" : "+"
        let priceChange = abs(change) > 1 ? change.asCurrencyWith2Decimals() : change.asCurrencyWith6Decimals()
        let priceChangePercent = coin.priceChangePercentage24H?.asPercentString() ?? ""
        return "\(sign)\(priceChange)(\(sign)\(priceChangePercent))"
    }
}

struct DetailLineChartView_Previews: PreviewProvider {
    static var previews: some View {
        DetailLineChartView(coin: dev.coin)
            .frame(height: 500)
    }
}
