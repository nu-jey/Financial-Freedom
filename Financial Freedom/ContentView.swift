//
//  ContentView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/15.
//

import SwiftUI
import Charts
struct ContentView: View {
    let upbit = Upbit.shared
    init() {
        upbit.searchCandle(targetMarket: "KRW-BTC")
    }
    var body: some View {
        VStack {
            ChartView()
                .padding()
        }
        .padding()
    }
}
struct ChartView: View {
    let upbit = Upbit.shared
    init() {
        upbit.searchCandle(targetMarket: "KRW-BTC")
        print(upbit.candles.count)
    }
    var body: some View {
        Chart(upbit.getCandle(), id: \.candleDateTimeKst) { candle in
            LineMark(x: .value("candleDateTimeKst", candle.candleDateTimeKst),
                       y: .value("tradePrice", candle.tradePrice))
            
            BarMark(x: .value("candleDateTimeKst", candle.candleDateTimeKst),
                       y: .value("tradePrice", candle.tradePrice))
        }
        .padding()
        .chartYScale(domain: [upbit.candles.map { $0.tradePrice}.min()!, upbit.candles.map { $0.tradePrice}.max()!])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
