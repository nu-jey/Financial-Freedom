//
//  ChartState.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/18.
//

import Foundation
import SwiftUI
enum ChartStateType {
    case up
    case upRight
    case right
    case downRight
    case down
}
struct ChartState {
    var state: ChartStateType
    var image: String {
        switch self.state {
        case ChartStateType.up:
            return "arrow.up.square"
        case .upRight:
            return "arrow.up.right.square"
        case .right:
            return "arrow.right.square"
        case .downRight:
            return "arrow.down.right.square"
        case .down:
            return "arrow.down.square"
        }
    }
}
