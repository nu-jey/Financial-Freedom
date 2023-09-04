//
//  ChartState.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/09/03.
//

import Foundation
import SwiftUI

enum ChartStateType {
    case upRight
    case right
    case downRight
}
struct ChartState {
    var state: ChartStateType
    var image: String {
        switch self.state {
        case .upRight:
            return "arrow.up.right.square"
        case .right:
            return "arrow.right.square"
        case .downRight:
            return "arrow.down.right.square"
        }
    }
}
