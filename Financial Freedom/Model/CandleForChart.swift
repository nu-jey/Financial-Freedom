//
//  CandleForChart.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/17.
//

import Foundation
import UpbitSwift
struct CandleForChart:Identifiable {
    var candle: UpbitCandle
    var id: UUID = UUID()
}
