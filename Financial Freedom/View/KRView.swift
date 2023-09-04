//
//  KRView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/16.
//

import SwiftUI

struct KRView: View {
    @StateObject var krViewModel:KRViewModel = KRViewModel()
    var body: some View {
        VStack {
            List(krViewModel.marketResponseOutput, id: \.mksc_shrn_iscd) { market in
                NavigationLink(destination: KRDetailView(mksc_shrn_iscd: market.mksc_shrn_iscd, hts_kor_isnm: market.hts_kor_isnm)) {
                    Text(market.hts_kor_isnm + ":" +  market.mksc_shrn_iscd)
                }
            }
            .onAppear {
                krViewModel.getToken()
                krViewModel.searchMarket()
            }
        }
    }
    
}

struct KRView_Previews: PreviewProvider {
    static var previews: some View {
        KRView()
    }
}
