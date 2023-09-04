//
//  File.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/16.
//

import Foundation
import UpbitSwift
class CryptocurrencyViewModel: ObservableObject {
    private let upSwift = UpbitSwift()
    @Published var marketList = UpbitMarketList()
    func getMarketAll () {
        upSwift.getMarketAll(isDetails: false) { result in
            switch result {
            case .success(let marketList):
                self.marketList = marketList!
            case .failure(let error):
                print(error.failureReason ?? "Not found error")
            }
        }
        
            
    }
    
}
