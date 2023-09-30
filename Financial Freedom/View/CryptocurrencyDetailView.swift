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
    @State var range: Int = 200
    @State var segmentationSelection:CandleType = .minute(.fifteen)
    @State var segmentationMinuteSelcetion:MinuteCandle = .fifteen
    @State var segmentationHourSelcetion:HourCandle = .four
    @State var isMAOn:Bool = false
    @State var isBBOn:Bool = false
    @State var isVolumeOn:Bool = false
    @StateObject var cryptocurrencyDetailViewModel = CryptocurrencyDetailViewModel()
    var body: some View {
        ScrollView {
            VStack {
                // 요약 정보 뷰
                SummaryInformationView
                // 차트 뷰
                cryptocurrencyDetailChartView
                cryptocurrencyDetailChartPickerView
                // 거래랑 차트 뷰
                cryptocurrencyDetailVolumeChartView
                // 정보뷰
                CryptocurrencyDeatilInformationView
                // 기술적 지표 뷰
                CryptocurrencyDeatilTechnicalindicatorsView
            }
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-100)
        .onAppear() {
            cryptocurrencyDetailViewModel.searchCandle(targetMarket: currentTicker, candleType: segmentationSelection, range: range)
            cryptocurrencyDetailViewModel.searchTicker(targetMarket: currentTicker)
            cryptocurrencyDetailViewModel.calcABRatio(targetMarket: currentTicker)
        }
        .toolbar {
            Menu {
                Toggle("MA", isOn: $isMAOn)
                    .padding(.leading, 10)
                Toggle("BB", isOn: $isBBOn)
                    .padding(.trailing, 10)
                Toggle("Volume Chart", isOn: $isVolumeOn)
                    .padding(.trailing, 10)
                
            }
            label: {
                Image(systemName: "chart.xyaxis.line")
            }
        }
    }
    var SummaryInformationView: some View  {
        VStack {
            HStack() {
                Text(currentTicker)
                    .font(.title)
                    .padding(.leading, 20)
                Image(systemName: cryptocurrencyDetailViewModel.chartState.image)
                Spacer()
                Text("\(Int(cryptocurrencyDetailViewModel.tickers.map { $0.tradePrice}.reduce(0, +)))")
                    .padding(.trailing, 20)
            }
            Divider()
        }
    }
    
    var cryptocurrencyDetailChartView: some View {
        Chart() {
            ForEach(cryptocurrencyDetailViewModel.chartData, id: \.0.timestamp) {candle in
                LineMark(x: .value("Time", candle.0.candleDateTimeKst), y: .value("Price", candle.0.tradePrice))
                    .interpolationMethod(.catmullRom) // 약간 곡선 형태
                    .foregroundStyle(by: .value("PRICE", "PRICE"))
                
//                        BarMark(x: .value("Time", candle.0.candleDateTimeKst),
//                                yStart: .value("Trade Price", candle.0.highPrice),
//                                yEnd: .value("Trade Price", candle.0.lowPrice))
                if isMAOn {
                    LineMark(x: .value("Time", candle.0.candleDateTimeKst), y: .value("MA", candle.1))
                        .foregroundStyle(by: .value("MA", "MA"))
                }
                if isBBOn {
                    LineMark(x: .value("Time", candle.0.candleDateTimeKst), y: .value("BBUP", candle.2))
                        .foregroundStyle(by: .value("BBUP", "BBUP"))
                    LineMark(x: .value("Time", candle.0.candleDateTimeKst), y: .value("BBDW", candle.3))
                        .foregroundStyle(by: .value("BBDW", "BBDW"))
                }
            }
        }
        .chartForegroundStyleScale(["PRICE": .blue, "MA":.red, "BBUP": .cyan, "BBDW":.green])
        .chartYScale(domain:cryptocurrencyDetailViewModel.chartRange.0...cryptocurrencyDetailViewModel.chartRange.1)
        .frame(height:  UIScreen.main.bounds.width / 2)
        .onChange(of: self.segmentationSelection) { changeCandleType in
            cryptocurrencyDetailViewModel.searchCandle(targetMarket: currentTicker, candleType: changeCandleType, range: range)
        }
    }
    
    var cryptocurrencyDetailChartPickerView: some View {
        VStack {
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
        }
    }
    var CryptocurrencyDeatilInformationView: some View {
        VStack {
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
            Divider()
        }
    }
    var cryptocurrencyDetailVolumeChartView: some View {
        VStack {
            if isVolumeOn {
                Chart() {
                    ForEach(cryptocurrencyDetailViewModel.adiData, id: \.1) { candle in
                        LineMark(x: .value("Time", candle.1), y: .value("ADI", candle.0))
                    }
                }
                .chartYScale(domain:cryptocurrencyDetailViewModel.volumeChartRange.0...cryptocurrencyDetailViewModel.volumeChartRange.1)
            }
            Divider()
        }
    }
    
    var CryptocurrencyDeatilTechnicalindicatorsView: some View {
        VStack {
            Chart() {
                ForEach(cryptocurrencyDetailViewModel.abratioData, id: \.1) { candle in
                    LineMark(x: .value("Time", candle.2), y: .value("A", candle.0))
                        .foregroundStyle(by: .value("ARatio", "ARatio"))
                    LineMark(x: .value("Time", candle.2), y: .value("B", candle.1))
                        .foregroundStyle(by: .value("BRaio", "BRaio"))
                }
            }
            .chartYScale(domain:cryptocurrencyDetailViewModel.abratioChartRange.0...cryptocurrencyDetailViewModel.abratioChartRange.1)
            .chartForegroundStyleScale(["ARatio": .red, "BRaio":.blue])
            Divider()
        }
    }
}


struct CryptocurrencyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptocurrencyDetailView(currentTicker: "KRW-BTC")
    }
}
