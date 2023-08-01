//
//  CryptocurrencyDetailViewModel.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/22.
//

import Foundation
import UpbitSwift

extension CandleType: Hashable {
    public static func == (lhs: CandleType, rhs: CandleType) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    public func hash(into hasher: inout Hasher) {
        switch self {
        case .minute(let value):
            hasher.combine(value)
        case .hour(let value):
            hasher.combine(value)
        case .days:
            hasher.combine(-1)
        case .weeks:
            hasher.combine(-2)
        case .months:
            hasher.combine(-3)
        }
    }
}

class CryptocurrencyDetailViewModel: ObservableObject {
    private let upSwift = UpbitSwift()
    @Published var candles = UpbitCandles()
    @Published var chartRange: (Double,Double) = (0,0)
    @Published var tickers = UpbitTickers()
    @Published var chartState = ChartState(state: .upRight)
    
    func searchCandle(targetMarket: String, candleType: CandleType, range: Int)  {
        upSwift.getCandle(candleType, market: targetMarket) { result in
            switch result {
            case .success(let candles):
                self.candles = candles!
                self.candles = Array(self.candles[..<min(range, self.candles.count)]).reversed()
                self.chartRange = (self.candles.map { $0.lowPrice }.min()!, self.candles.map { $0.highPrice }.max()!)
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
    
    func searchTicker(targetMarket: String) {
        upSwift.getTickers(market: [targetMarket]) { result in
            switch result {
            case .success(let tickers):
                self.tickers = tickers!
                if !tickers!.isEmpty {
                    switch self.tickers.first!.change {
                    case "RISE":
                        self.chartState = ChartState(state: .upRight)
                    case "FALL":
                        self.chartState = ChartState(state: .downRight)
                    default:
                        self.chartState = ChartState(state: .right)
                    }
                    print(self.tickers.first!.market, self.tickers.first!.change)
                }
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
        
    }
}
