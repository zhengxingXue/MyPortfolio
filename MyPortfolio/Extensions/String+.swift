//
//  String+.swift
//  String+
//
//  Created by Jim's MacBook Pro on 9/5/21.
//

import Foundation
import SwiftUI

extension String {
   func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}
