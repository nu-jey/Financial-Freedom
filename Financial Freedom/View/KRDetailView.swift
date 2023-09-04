//
//  KRDetailView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/09/03.
//

import SwiftUI
import Charts
import UpbitSwift

struct KRDetailView: View {
    @StateObject var krDetailViewModel:KRDetailViewModel = KRDetailViewModel()
    @State var mksc_shrn_iscd:String
    @State var hts_kor_isnm:String
    @State var segmentationSelection:String = "D"
    var body: some View {
        ScrollView {
            VStack {
                // 요약 정보 뷰
                HStack() {
                    Text(hts_kor_isnm + ":" + mksc_shrn_iscd)
                        .font(.title)
                        .padding(.leading, 20)
                    Image(systemName: krDetailViewModel.signImage.image)
                    Spacer()
                    Text((krDetailViewModel.inquirePriceResponseOutput?.stck_oprc) ?? "")
                        .padding(.trailing, 20)
                }
                Divider()
                // 차트 뷰
                Chart() {
                    ForEach(krDetailViewModel.inquireDailyPriceResponseOutput, id: \.stck_bsop_date) { candle in
                        LineMark(x: .value("Time", candle.stck_bsop_date), y: .value("Price", candle.stck_clpr))
                            .interpolationMethod(.catmullRom) // 약간 곡선 형태
//                        BarMark(x: .value("Time", candle.stck_bsop_date),
//                                yStart: .value("High Price", candle.stck_hgpr),
//                                yEnd: .value("Low Price", candle.stck_lwpr))
                    }
                }
                
                Picker(selection:$segmentationSelection) {
                    Text("days")
                        .tag("D")
                    Text("weeks")
                        .tag("W")
                    Text("months")
                        .tag("M")
                } label: {
                    Text("123")
                }
                .frame(height: 20)
                .pickerStyle(SegmentedPickerStyle())
                .scaledToFit()
                .onChange(of: self.segmentationSelection) { changeCandleType in
                    krDetailViewModel.inquireDailyPrice(fid_cond_mrkt_div_code: "J", fid_input_iscd: mksc_shrn_iscd, fid_period_div_code: changeCandleType, fid_org_adj_prc: "1")
                }
            }
        }
        .onAppear {
            krDetailViewModel.inquirePrice(fid_cond_mrkt_div_code: "J", fid_input_iscd: mksc_shrn_iscd)
            krDetailViewModel.inquireDailyPrice(fid_cond_mrkt_div_code: "J", fid_input_iscd: mksc_shrn_iscd, fid_period_div_code: segmentationSelection, fid_org_adj_prc: "1")
        }
    }
}

struct KRDetailView_Previews: PreviewProvider {
    static var previews: some View {
        KRDetailView(mksc_shrn_iscd: "005930", hts_kor_isnm: "삼성전자")
    }
}
