//
//  CryptocurrencyView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/16.
//

import SwiftUI

struct CryptocurrencyView: View {
    @StateObject var cryptocurrencyViewModel = CryptocurrencyViewModel()
    var body: some View {
        List(cryptocurrencyViewModel.marketList.filter({ $0.market.contains("KRW-") }), id: \.market) { market in
            NavigationLink(destination:CryptocurrencyDetailView(currentTicker: market.market)) {
                Text(market.koreanName)
            }
            
        }
        .onAppear() {
            cryptocurrencyViewModel.getMarketAll()
        }
    }
}

struct CryptocurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CryptocurrencyView()
    }
}
