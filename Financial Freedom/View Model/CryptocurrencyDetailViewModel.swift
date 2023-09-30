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
    @Published var chartData:[(UpbitCandle, Double, Double, Double)] = []
    @Published var bollingerBands:[(Double,Double)] = []
    @Published var adiData:[(Double, String)] = []
    @Published var volumeChartRange: (Double,Double) = (0,0)
    @Published var abratioData:[(Double, Double, String)] = []
    @Published var abratioChartRange: (Double, Double) = (0,0)
    private var preADIValue:Double = 0
    
    func searchCandle(targetMarket: String, candleType: CandleType, range: Int)  {
        upSwift.getCandle(candleType, market: targetMarket) { result in
            switch result {
            case .success(let candles):
                self.chartData = []
                self.bollingerBands = []
                self.adiData = []
                self.candles = candles!
                self.candles = Array(self.candles[..<min(range, self.candles.count)]).reversed()
                self.ma = self.makeMA(self.candles.map { $0.tradePrice }, self.candles.map { $0.candleDateTimeKst}, 5)
                for i in 0..<self.candles.count {
                    self.chartData.append((self.candles[i], self.ma[i].0, self.bollingerBands[i].0, self.bollingerBands[i].1))
                    self.adiData.append((self.calcADI(close: self.candles[i].tradePrice, high: self.candles[i].highPrice, low: self.candles[i].lowPrice, volume: self.candles[i].candleAccTradeVolume), self.candles[i].candleDateTimeKst))
                }
                self.chartRange = (self.bollingerBands.map { $0.1 }.min()!, self.bollingerBands.map { $0.0 }.max()!)
                self.volumeChartRange = (self.adiData.map { $0.0}.min()!, self.adiData.map { $0.0}.max()!)
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
            let priceArray:[Double]
            let bbValue:(Double, Double)
            if i+1 < period {
                priceArray = Array(prices[...i])
                calcPrice = priceArray.reduce(0, +) / Double(i+1)
            } else if i > (length-period)  {
                priceArray = Array(prices[i...])
                calcPrice =  priceArray.reduce(0, +) / Double(length-i)
            } else {
                priceArray = Array(prices[(i-period+1)...i])
                calcPrice = ((priceArray.reduce(0, +) / Double(period)))
            }
            let sdValue = calcStandardDeviation(calcPrice, priceArray)*2
            bbValue = (calcPrice + sdValue, calcPrice - sdValue)
            self.bollingerBands.append(bbValue)
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
    
    func calcStandardDeviation(_ average: Double, _ inputData:[Double]) -> Double {
        var res = inputData.map { pow(abs($0 - average), 2) }
        return sqrt(res.reduce(0, +) / Double(inputData.count))
    }

    func calcADI(close: Double, high:Double, low:Double, volume:Double) -> Double {
        let adi = volume * ((close - low) - (high - close)) / (high - low)
        preADIValue += adi
        return preADIValue
    }
}

// 기술적 지표 계산
extension CryptocurrencyDetailViewModel {
    func calcABRatio(targetMarket:String)  {
//        [A-Ratio 와 B-Ratio 의 교차]
//        B-Ratio의 A-Ratio 상향돌파 -> 강세 (매수)
//        B-Ratio의 A-Ratio 하향돌파 -> 약세 (매도)
//        [A-Ratio 와 B-Ratio 의 동반 움직임]
//        A-Ratio 와 B-Ratio 가 동반 상승시에는 추가 상승이 예상된다.
//        A-Ratio 와 B-Ratio 가 동반 하락시에는 추가 하락이 예상된다.
        let abratioPeriod:Int = 20
        func calcARtio(candles: UpbitCandles) -> Double {
            return 100 * candles.map { $0.highPrice - $0.openingPrice }.reduce(0, +) / candles.map { $0.openingPrice - $0.lowPrice }.reduce(0, +)
        }
        func calcBRatio(candles: UpbitCandles) -> Double {
            return 100 * candles.map { $0.highPrice - ($0.tradePrice - Double($0.changePrice ?? 0))}.reduce(0, +) / candles.map { ($0.tradePrice - Double($0.changePrice ?? 0)) - $0.lowPrice }.reduce(0, +)
        }
        upSwift.getCandle(.days, market: targetMarket) { result in
                switch result {
                case .success(let candles):
                    let candles = candles!
                    self.abratioData = []
                    for (idx, candle) in candles.reversed().enumerated() {
                        if idx >= (abratioPeriod-1) {
                            let aRatio = calcARtio(candles: Array(candles[idx-abratioPeriod+1...idx]))
                            let bRatio = calcBRatio(candles: Array(candles[idx-abratioPeriod+1...idx]))
                            self.abratioData.append((aRatio, bRatio, candle.candleDateTimeKst))
                        }
                    }
                    self.abratioChartRange = (self.abratioData.map { min($0.0, $0.1) }.min()!, self.abratioData.map { max($0.0, $0.1) }.max()!)
                case .failure(let error):
                    print(error.failureReason ?? "Not found error")
                }
        }
    }
}
