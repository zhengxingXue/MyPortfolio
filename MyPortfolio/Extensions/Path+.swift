//
//  Path+.swift
//  Path+
//
//  Created by Jim's MacBook Pro on 9/2/21.
//

import SwiftUI

extension Path {
    static func linePath(points: [Double], step: CGPoint, padding: CGSize) -> Path {
        var path = Path()
        guard points.count > 1, let offset = points.min() else { return path }
        let start = CGPoint(
            x: padding.width / 2,
            y: CGFloat(points[0] - offset) * step.y + padding.height / 2
        )
        path.move(to: start)
        for index in points.indices {
            let temp = CGPoint(
                x: step.x * CGFloat(index) + padding.width / 2,
                y: CGFloat(points[index] - offset) * step.y + padding.height / 2
            )
            path.addLine(to: temp)
        }
        return path
    }
    
    static func horizontalBaseLine(points: [Double], step: CGPoint, padding: CGSize, width: CGFloat) -> Path {
        var path = Path()
        guard points.count > 1, let offset = points.min() else { return path }
        let y = CGFloat(points[0] - offset) * step.y + padding.height / 2
        path.move(to: CGPoint(x: padding.width / 2, y: y))
        path.addLine(to: CGPoint(x: width - padding.width / 2, y: y))
        return path
    }
}
