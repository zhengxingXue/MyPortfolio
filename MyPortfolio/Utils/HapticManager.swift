//
//  HapticManager.swift
//  HapticManager
//
//  Created by Jim's MacBook Pro on 9/5/21.
//

import Foundation
import SwiftUI

class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
}
