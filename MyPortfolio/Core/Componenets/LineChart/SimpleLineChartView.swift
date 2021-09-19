//
//  SimpleLineChartView.swift
//  SimpleLineChartView
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

struct SimpleLineChartView: View {
    var data: [Double]
    private let dataCount: Int
    
    var lineWidth: CGFloat = 1
    var padding = CGSize(width: 0, height: 20)
    
    init(prices: [[Double]]) {
        self.data = prices.map{ $0[1] }
        self.dataCount = max(24 * 60 / 5, self.data.count - 1)
    }
    
    var body: some View {
        GeometryReader { geometry in
            // baseline
            Path.horizontalBaseLine(points: data, step: getStep(in: geometry), padding: padding, width: geometry.size.width)
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundColor(.theme.secondaryText)
            // stock price
            Path.linePath(points: data, step: getStep(in: geometry), padding: padding)
                .stroke(lineColor, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
        }
        .rotationEffect(.degrees(180), anchor: .center)
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }

    private func getStep(in geometry: GeometryProxy) -> CGPoint {
        var step = CGPoint(x: 0, y: 0)
        guard data.count > 1, let min = data.min(), let max = data.max() else { return step }
        step.x = (geometry.size.width - padding.width) / CGFloat(dataCount)
        step.y = (geometry.size.height - padding.height) / CGFloat(max - min)
        return step
    }
    
    private var lineColor: Color { (data.last ?? 0) - (data.first ?? 0) > 0 ? Color.theme.green : Color.theme.red }
}

//struct SimpleLineChartView_Previews: PreviewProvider {
//    static var previews: some View {
//        SimpleLineChartView(data: dev.coin.sparklineIn7D?.price ?? [])
//            .frame(height: 200)
//    }
//}
