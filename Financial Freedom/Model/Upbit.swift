//
//  Upbit.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/15.
//

import Foundation
import UpbitSwift

class Upbit {
    static let shared = Upbit()
    private let upSwift = UpbitSwift()
    private var marketList = UpbitMarketList()
    var candles = UpbitCandles()
    private init() { }
    func searchMarketList() {
        Upbit.shared.upSwift.getMarketAll(isDetails: false) { result in
            switch result {
            case .success(let marketList):
                Upbit.shared.marketList = marketList!
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
    func searchCandle(targetMarket: String)  {
        Upbit.shared.upSwift.getCandle(.hour(.one), market: targetMarket) { result in
            switch result {
            case .success(let candles):
                self.candles = candles!
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
    func getCandle() -> UpbitCandles {
        if candles.count == 200 {
            candles = Array(candles[..<20])
        }
        return candles
    }
}

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

struct CandleForChart:Identifiable {
    var candle: UpbitCandle
    var id: UUID = UUID()
}


