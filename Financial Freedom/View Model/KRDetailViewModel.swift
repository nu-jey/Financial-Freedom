//
//  KRDetailViewModel.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/08/04.
//

import Foundation

class KRDetailViewModel:ObservableObject {
    @Published var inquirePriceResponseOutput:InquirePriceResponseOutput?
    func inquirePrice(koreanInvestment: KoreanInvestment, fid_cond_mrkt_div_code:String, fid_input_iscd:String) {
        koreanInvestment.inquirePrice(fid_cond_mrkt_div_code: fid_cond_mrkt_div_code, fid_input_iscd: fid_input_iscd){ (state, data) in
            if state {
                DispatchQueue.main.async { [weak self] in
                    self!.inquirePriceResponseOutput = data as! InquirePriceResponseOutput
                }
            } else {
                print(data)
            }
        }
    }
}
