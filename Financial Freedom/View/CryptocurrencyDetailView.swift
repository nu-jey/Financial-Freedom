//
//  MarketDetailView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/16.
//

import SwiftUI
import UpbitSwift
import Charts
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
            break
        case .weeks:
            break
        case .months:
            break
        }
    }
    
    
}
struct CryptocurrencyDetailView: View {
    @State var currentTicker: String?
    @State var segmentationSelection: CandleType = .minute(.fifteen )
    @State var range: Int = 10
    @StateObject var cryptocurrencyDetailViewModel = CryptocurrencyDetailViewModel()
    var body: some View {
        ScrollView {
            VStack {
                HStack() {
                    Text(currentTicker!)
                        .font(.title)
                        .padding(.leading, 20)
                    Spacer()
                }
                Divider()
                // 요약 정보 뷰
                Divider()
                Chart() {
                    ForEach(cryptocurrencyDetailViewModel.candles, id: \.timestamp) {candle in
                        LineMark(x: .value("Time", candle.candleDateTimeKst), y: .value("Price", candle.tradePrice))
                            .interpolationMethod(.catmullRom) // 약간 곡선 형태
                        BarMark(x: .value("Time", candle.candleDateTimeKst),
                                yStart: .value("Trade Price", candle.highPrice),
                                yEnd: .value("Trade Price", candle.lowPrice))
                    }
                }
                .chartYScale(domain:cryptocurrencyDetailViewModel.chartRange.0...cryptocurrencyDetailViewModel.chartRange.1)
                .frame(height:  UIScreen.main.bounds.width / 2)
                Picker("Candle", selection: $segmentationSelection.animation(.easeInOut)) {
                    Text("minutes")
                        .tag(CandleType.minute(.fifteen))
                        .onTapGesture {
                            print(segmentationSelection)
                        }
                    Text("hours")
                        .tag(CandleType.hour(.four))
                        .onTapGesture {
                            print(segmentationSelection)
                        }
                    Text("days")
                        .tag(CandleType.days)
                    Text("weeks")
                        .tag(CandleType.weeks)
                    Text("months")
                        .tag(CandleType.months)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Divider()
                
            }
            .onAppear() {
                cryptocurrencyDetailViewModel.searchCandle(targetMarket: currentTicker!, candleType: segmentationSelection, range: 100)
            }
        }
    }
}


struct CryptocurrencyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptocurrencyDetailView(currentTicker: "KRW-BTC")
    }
}
