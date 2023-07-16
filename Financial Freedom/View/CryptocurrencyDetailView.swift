//
//  MarketDetailView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/16.
//

import SwiftUI
import UpbitSwift

enum ChartSection: String, CaseIterable {
    case minute = "Minutes"
    case hour = "Hours"
    case days = "Days"
    case weeks = "Weeks"
    case months = "Months"
}

struct CryptocurrencyDetailView: View {
    @State var currentTicker: String?
    @State var segmentationSelection : ChartSection = .minute
    @StateObject var cryptocurrencyDetailViewModel = CryptocurrencyDetailViewModel()
    var body: some View {
        VStack {
            Text(currentTicker!)
                .font(.title)
            Picker("", selection: $segmentationSelection) {
                ForEach(ChartSection.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
        }
        .onAppear() {
            cryptocurrencyDetailViewModel.searchCandle(targetMarket: currentTicker!, candleType: .minute(.fifteen))
        }
    }
}

struct CryptocurrencyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CryptocurrencyDetailView(currentTicker: "KRW-BTC")
    }
}
