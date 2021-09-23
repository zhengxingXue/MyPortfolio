//
//  PortfolioRowView.swift
//  MyPortfolio
//
//  Created by Jim's MacBook Pro on 9/22/21.
//

import SwiftUI

struct PortfolioRowView: View {
    
    var portfolio: PortfolioEntity
    
    var body: some View {
        HStack {
            Text(portfolio.name ?? "-")
            Spacer()
            VStack(alignment: .trailing) {
                Text((portfolio.currentPrice * portfolio.amount).asCurrencyWith2Decimals())
                    .bold()
                Text(portfolio.amount.asNumberString())
            }
            Text(0.asCurrency())
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .foregroundColor(.theme.accent)
    }
}

//struct PortfolioRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        PortfolioRowView(portfolio: dev.portfolioEntity)
//    }
//}
