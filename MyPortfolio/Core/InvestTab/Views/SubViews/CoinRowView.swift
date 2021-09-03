//
//  CoinRowView.swift
//  CoinRowView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct CoinRowView: View {
    
    var coin: CoinModel
    @Binding var isEditing: Bool
    
    var body: some View {
        HStack {
            leftColumn
                .frame(width: UIScreen.main.bounds.width / divider, alignment: .leading)
                .padding(.vertical)
            if !isEditing {
                SimpleLineChartView(data: getData())
                    .frame(width: UIScreen.main.bounds.width / divider)
                Spacer()
                rightColumn
                    .padding(.vertical)
            }
        }
        .background(NavigationLink("", destination: CoinDetailView(coin: coin)).opacity(0))
    }
    
    private let divider: CGFloat = 3.8
    private func getData() -> [Double] {
        let sparkline7D = coin.sparklineIn7D?.price ?? []
        return sparkline7D.suffix(Int(1 * sparkline7D.count / 7))
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            CoinRowView(coin: dev.coin, isEditing: .constant(false))
            CoinRowView(coin: dev.coin, isEditing: .constant(false))
        }
        .listStyle(.plain)
        .preferredColorScheme(.light)
        
        List{
            CoinRowView(coin: dev.coin, isEditing: .constant(false))
            CoinRowView(coin: dev.coin, isEditing: .constant(false))
        }
        .listStyle(.plain)
        .preferredColorScheme(.dark)
    }
}

extension CoinRowView {
    private var leftColumn: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(coin.symbol.uppercased())
                .font(.body)
                .foregroundColor(.theme.accent)
            Text(coin.name)
                .lineLimit(1)
                .font(.caption)
                .foregroundColor(.theme.secondaryText)
        }
    }
    
    private var rightColumn: some View {
        Text("\(coin.currentPrice.asCurrencyWith6Decimals())")
            .font(.callout)
            .foregroundColor(.theme.background)
            .frame(minWidth: 80)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? .green : .red)
            )
    }
    
}
