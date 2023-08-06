//
//  KRDetailViewModel.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/08/04.
//

import Foundation

class KRDetailViewModel:ObservableObject {
    @Published var inquirePriceResponseOutput:InquirePriceResponseOutput?
    @Published var inquireDailyPriceResponseOutput:[InquireDailyPriceResponseOutput] = []
    @Published var signImage = KRChartState(state: .right)
    @Published var chartRange: (Double,Double) = (0,0)
    
    func inquirePrice(koreanInvestment: KoreanInvestment, fid_cond_mrkt_div_code:String, fid_input_iscd:String) {
        koreanInvestment.inquirePrice(fid_cond_mrkt_div_code: fid_cond_mrkt_div_code, fid_input_iscd: fid_input_iscd){ (state, data) in
            if state {
                DispatchQueue.main.async { [weak self] in
                    self!.inquirePriceResponseOutput = data as! InquirePriceResponseOutput
                    switch self!.inquirePriceResponseOutput?.prdy_vrss_sign {
                    case "1":
                        self?.signImage = KRChartState(state: .up)
                    case "2":
                        self?.signImage = KRChartState(state: .upRight)
                    case "3":
                        self?.signImage = KRChartState(state: .right)
                    case "4":
                        self?.signImage = KRChartState(state: .down)
                    case "5":
                        self?.signImage = KRChartState(state: .downRight)
                    default:
                        self?.signImage = KRChartState(state: .unknown)
                    }
                }
            } else {
                print(data)
            }
        }
    }
    func inquireDailyPrice(koreanInvestment: KoreanInvestment, fid_cond_mrkt_div_code:String, fid_input_iscd:String, fid_period_div_code:String, fid_org_adj_prc:String) {
        koreanInvestment.inquireDailyPrice(fid_cond_mrkt_div_code: fid_cond_mrkt_div_code, fid_input_iscd: fid_input_iscd, fid_period_div_code: fid_period_div_code, fid_org_adj_prc: fid_org_adj_prc) { (state, data) in
            DispatchQueue.main.async { [weak self] in
                self!.inquireDailyPriceResponseOutput = data as! [InquireDailyPriceResponseOutput]
                self!.inquireDailyPriceResponseOutput = Array(self!.inquireDailyPriceResponseOutput).reversed()
                self!.chartRange.0 = self!.inquireDailyPriceResponseOutput.map { Double($0.stck_clpr)! }.min()! * 0.9
                self!.chartRange.1 = self!.inquireDailyPriceResponseOutput.map { Double($0.stck_clpr)! }.max()! * 1.1
            }
        }
    }
}
