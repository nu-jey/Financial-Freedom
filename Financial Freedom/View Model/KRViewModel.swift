//
//  KRViewModel.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/24.
//

import Foundation

class KRViewModel:ObservableObject {
    private var koreanInvestment = KoreanInvestment.shared
    @Published var marketResponseOutput:[MarketResponseOutput] = []
    @Published var tokenState = false
    
    func getToken() {
        self.koreanInvestment.getToken() { (state) in
            DispatchQueue.main.async { [weak self] in
                self!.tokenState = state
            }
        }
    }
    
    func searchMarket()   {
        self.koreanInvestment.searchMarket(tokenState: tokenState) { (state, data) in
            if state {
                DispatchQueue.main.async { [weak self] in
                    self!.marketResponseOutput = data as! [MarketResponseOutput]
                }
            } else {
                print(data)
            }
        }
    }
    
}
