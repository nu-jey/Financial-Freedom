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
    @State var range: Int = 100
    @State var segmentationSelection:CandleType = .minute(.fifteen)
    @State var segmentationMinuteSelcetion:MinuteCandle = .fifteen
    @State var segmentationHourSelcetion:HourCandle = .four
    @StateObject var cryptocurrencyDetailViewModel = CryptocurrencyDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                // 요약 정보 뷰
                HStack() {
                    Text(currentTicker)
                        .font(.title)
                        .padding(.leading, 20)
                    Image(systemName: cryptocurrencyDetailViewModel.chartState.image)
                    Spacer()
                    Text("\(cryptocurrencyDetailViewModel.tickers.map { $0.tradePrice}.reduce(0, +))")
                        .padding(.trailing, 20)
                }
                Divider()
                Chart(cryptocurrencyDetailViewModel.chartData, id: \.0.candleDateTimeKst) { candle in
                    BarMark(x: .value("Time", candle.0.candleDateTimeKst),
                            yStart: .value("Trade Price", candle.0.highPrice),
                            yEnd: .value("Trade Price", candle.0.lowPrice))
                    LineMark(x: .value("Time", candle.0.candleDateTimeKst), y: .value("Price", candle.0.tradePrice))
                        .interpolationMethod(.catmullRom) // 약간 곡선 형태
                        .foregroundStyle(.red)
                        .foregroundStyle(by: .value("Value", "Trade Price"))
                        .lineStyle(StrokeStyle(lineWidth: 5))
                    LineMark(x: .value("Time", candle.0.candleDateTimeKst), y: .value("Price", candle.1))
                        .interpolationMethod(.catmullRom) // 약간 곡선 형태
                        .foregroundStyle(.green)
                        .foregroundStyle(by: .value("Value", "MA"))
                        .lineStyle(StrokeStyle(lineWidth: 5))

                }
                .chartForegroundStyleScale([
                    "MA": .green,
                    "Trade Price": .red
                ])
                .chartYScale(domain:cryptocurrencyDetailViewModel.chartRange.0...cryptocurrencyDetailViewModel.chartRange.1)
                .frame(height:  UIScreen.main.bounds.width / 2)
                .onChange(of: self.segmentationSelection) { changeCandleType in
                    cryptocurrencyDetailViewModel.searchCandle(targetMarket: currentTicker, candleType: changeCandleType, range: range)
                }
                HStack {
                    Picker("M", selection: $segmentationMinuteSelcetion) {
                        Text("1m")
                            .tag(MinuteCandle.one)
                        Text("3m")
                            .tag(MinuteCandle.three)
                        Text("5m")
                            .tag(MinuteCandle.five)
                        Text("10m")
                            .tag(MinuteCandle.ten)
                        Text("15m")
                            .tag(MinuteCandle.fifteen)
                        Text("30m")
                            .tag(MinuteCandle.thirty)
                    }
                    .pickerStyle(.menu)
                    .buttonStyle(.bordered)
                    .onChange(of: self.segmentationMinuteSelcetion) { changeMinute in
                        segmentationSelection = CandleType.minute(changeMinute)
                    }
                    .accentColor(.black)
                    .font(.title)
                    
                    Picker("H", selection: $segmentationHourSelcetion) {
                        Text("1h")
                            .tag(HourCandle.one)
                        Text("4h")
                            .tag(HourCandle.four)
                    }
                    .pickerStyle(.menu)
                    .buttonStyle(.bordered)
                    .onChange(of: self.segmentationHourSelcetion) { changeHour in
                        segmentationSelection = CandleType.hour(changeHour)
                    }
                    .accentColor(.black)
                    Picker(selection:$segmentationSelection) {
                        Text("days")
                            .font(.title)
                            .tag(CandleType.days)
                        Text("weeks")
                            .tag(CandleType.weeks)
                        Text("months")
                            .tag(CandleType.months)
                    } label: {
                        Text("123")
                    }
                    .frame(height: 20)
                    .pickerStyle(SegmentedPickerStyle())
                    .scaledToFit()
                    
                }
                .padding()
                Divider()
                // 정보뷰
                ScrollView(.horizontal) {
                    HStack {
                        VStack {
                            HStack {
                                Text("개장가")
                                Spacer()
                                Text("\(Int(cryptocurrencyDetailViewModel.tickers.map { $0.openingPrice}.reduce(0,+)))")
                            }
                            HStack {
                                Text("최고가")
                                Spacer()
                                Text("\(Int(cryptocurrencyDetailViewModel.tickers.map { $0.highPrice}.reduce(0,+)))")
                            }
                            HStack {
                                Text("최저가")
                                Spacer()
                                Text("\(Int(cryptocurrencyDetailViewModel.tickers.map { $0.lowPrice}.reduce(0,+)))")
                            }
                        }
                        Divider()
                        VStack {
                            HStack {
                                Text("24H 누적액")
                                Spacer()
                                Text("\(Int(cryptocurrencyDetailViewModel.tickers.map { $0.accTradePrice24H}.reduce(0,+)))")
                            }
                            HStack {
                                Text("52주 최고가")
                                Spacer()
                                Text("\(Int(cryptocurrencyDetailViewModel.tickers.map { $0.highest52_WeekPrice}.reduce(0,+)))")
                            }
                            HStack {
                                Text("52주 최주가")
                                Spacer()
                                Text("\(Int(cryptocurrencyDetailViewModel.tickers.map { $0.lowest52_WeekPrice}.reduce(0,+)))")
                            }
                        }
                        Divider()
                        // 추후 적용 알고리즘에 따라 정보 추가
                    }
                    .padding()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
        .onAppear() {
            cryptocurrencyDetailViewModel.searchCandle(targetMarket: currentTicker, candleType: segmentationSelection, range: range)
            cryptocurrencyDetailViewModel.searchTicker(targetMarket: currentTicker)
        }
    }
}


struct CryptocurrencyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptocurrencyDetailView(currentTicker: "KRW-BTC")
    }
}
