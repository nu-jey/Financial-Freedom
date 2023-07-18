//
//  MarketDetailView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/16.
//

import SwiftUI
import UpbitSwift
import Charts

struct CryptocurrencyDetailView: View {
    @State var currentTicker:String
    @State var segmentationSelection: CandleType = .minute(.fifteen )
    @State var range: Int = 100
    @StateObject var cryptocurrencyDetailViewModel = CryptocurrencyDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack() {
                    Text(currentTicker)
                        .font(.title)
                        .padding(.leading, 20)
                    Image(systemName: cryptocurrencyDetailViewModel.chartState.image)
                    Spacer()
                    Text("\(cryptocurrencyDetailViewModel.tickers.map { $0.tradePrice}.reduce(0, +))")
                        .padding(.trailing, 20)
                }
                .onAppear {
                    cryptocurrencyDetailViewModel.searchTicker(targetMarket: currentTicker)
                }
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
                .onChange(of: self.segmentationSelection) { changeCandleType in
                        cryptocurrencyDetailViewModel.searchCandle(targetMarket: currentTicker, candleType: changeCandleType, range: range)
                }
                Picker("Candle", selection:$segmentationSelection) {
                    Text("minutes")
                        .tag(CandleType.minute(.fifteen))
                    Text("hours")
                        .tag(CandleType.hour(.four))
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
                cryptocurrencyDetailViewModel.searchCandle(targetMarket: currentTicker, candleType: segmentationSelection, range: range)
                cryptocurrencyDetailViewModel.searchTicker(targetMarket: currentTicker)
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
    }
}


struct CryptocurrencyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptocurrencyDetailView(currentTicker: "KRW-BTC")
    }
}
