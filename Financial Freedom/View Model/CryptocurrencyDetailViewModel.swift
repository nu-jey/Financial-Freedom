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
    @Published var ma: [(Double, String)] = []
    @Published var tickers = UpbitTickers()
    @Published var chartState = ChartState(state: .upRight)
    @Published var chartData:[(UpbitCandle, Double)] = []
    @Published var trendData:Dictionary<String,Bool> = [:] // 시점과 상태(true: 고점, false: 저점) 기록
    func searchCandle(targetMarket: String, candleType: CandleType, range: Int)  {
        upSwift.getCandle(candleType, market: targetMarket) { result in
            switch result {
            case .success(let candles):
                self.candles = candles!
                self.candles = Array(self.candles[..<min(range, self.candles.count)]).reversed()
                self.chartRange = (self.candles.map { $0.lowPrice }.min()!, self.candles.map { $0.highPrice }.max()!)
                self.ma = self.makeMA(self.candles.map { $0.tradePrice }, self.candles.map { $0.candleDateTimeKst}, 5)
                self.chartData = []
                for i in 0..<self.candles.count {
                    self.chartData.append((self.candles[i], self.ma[i].0))
                    if (i>0) && (i+1 == self.candles.count) {
                        
                    }
                }
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
    }
    
    func makeMA(_ prices:[Double], _ timeLine:[String], _ period: Int) -> [(Double,String)] {
        var res:[(Double,String)]  = []
        let length = prices.count
        for i in 0..<length {
            let calcPrice: Double
            if i+1 < period {
                calcPrice = (prices[...i].reduce(0, +) / Double(i+1))
            } else if i > (length-period)  {
                calcPrice = (prices[i...].reduce(0, +) / Double(length-i))
            } else {
                calcPrice = ((prices[(i-period+1)...i].reduce(0, +) / Double(period)))
            }
            res.append((calcPrice, timeLine[i]))
        }
        return res
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
