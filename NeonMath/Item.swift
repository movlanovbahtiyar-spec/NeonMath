//
//  Item.swift
//  NeonMath
//
//  Created by Bahtiyar  on 5.06.2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
