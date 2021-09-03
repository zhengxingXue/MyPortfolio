//
//  CoinRowView.swift
//  CoinRowView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    
    var body: some View {
        HStack {
            leftColumn
            Spacer()
            rightColumn
        }
        .padding(.vertical)
        .background(NavigationLink("", destination: Text("The detail view of \(coin.name)")).opacity(0))
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            CoinRowView(coin: dev.coin)
            CoinRowView(coin: dev.coin)
        }
        .listStyle(.plain)
        .preferredColorScheme(.light)
        
        List{
            CoinRowView(coin: dev.coin)
            CoinRowView(coin: dev.coin)
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
            .foregroundColor(.white)
            .frame(minWidth: 80)
            .padding(.vertical, 8)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .foregroundColor((coin.priceChangePercentage24H ?? 0) >= 0 ? .green : .red)
            )
    }
    
}
