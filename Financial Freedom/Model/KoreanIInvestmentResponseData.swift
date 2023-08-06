//
//  KoreanIInvestmentResponseData.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/08/04.
//

import Foundation

// oauth 토큰 발급
struct TokenResponse: Codable {
    let access_token:String!
}

// 거래량순위
struct MarketResponse: Codable {
    let output:[MarketResponseOutput]?
    let rt_cd:String?
    let msg_cd:String?
    let msg1:String?
}

// 거래량 순위 - output
struct MarketResponseOutput: Codable {
    let hts_kor_isnm:String!
    let mksc_shrn_iscd:String!
    let data_rank:String!
    let stck_prpr:String!
    let prdy_vrss_sign:String!
    let prdy_vrss:String!
    let prdy_ctrt:String!
    let acml_vol:String!
    let prdy_vol:String!
    let lstn_stcn:String!
    let avrg_vol:String!
    let n_befr_clpr_vrss_prpr_rate:String!
    let vol_inrt:String!
    let vol_tnrt:String!
    let nday_vol_tnrt:String!
    let avrg_tr_pbmn:String!
    let tr_pbmn_tnrt:String!
    let nday_tr_pbmn_tnrt:String!
    let acml_tr_pbmn:String!
}

// 주식 현재가 시세
struct InquirePriceResponse:Codable {
    let rt_cd:String?
    let msg_cd:String?
    let msg1:String?
    let output:InquirePriceResponseOutput
}

struct InquirePriceResponseOutput:Codable {
    let marg_rate:String!
    let rprs_mrkt_kor_name:String!
    let new_hgpr_lwpr_cls_code:String!
    let temp_stop_yn:String!
    let oprc_rang_cont_yn:String!
    let clpr_rang_cont_yn:String!
    let crdt_able_yn:String!
    let grmn_rate_cls_code:String!
    let elw_pblc_yn:String!
    let acml_tr_pbmn:String!
    let acml_vol:String!
    let hts_frgn_ehrt:String!
    let frgn_ntby_qty:String!
    let pgtr_ntby_qty:String!
    let pvt_scnd_dmrs_prc:String!
    let pvt_frst_dmrs_prc:String!
    let pvt_pont_val:String!
    let pvt_frst_dmsp_prc:String!
    let pvt_scnd_dmsp_prc:String!
    let dmrs_val:String!
    let dmsp_val:String!
    let cpfn:String!
    let rstc_wdth_prc:String!
    let stck_fcam:String!
    let stck_sspr:String!
    let aspr_unit:String!
    let hts_deal_qty_unit_val:String!
    let lstn_stcn:String!
    let hts_avls:String!
    let per:String!
    let pbr:String!
    let stac_month:String!
    let vol_tnrt:String!
    let eps:String!
    let bps:String!
    let d250_hgpr:String!
    let d250_hgpr_date:String!
    let d250_hgpr_vrss_prpr_rate:String!
    let d250_lwpr:String!
    let d250_lwpr_date:String!
    let d250_lwpr_vrss_prpr_rate:String!
    let stck_dryy_hgpr:String!
    let dryy_hgpr_vrss_prpr_rate:String!
    let dryy_hgpr_date:String!
    let stck_dryy_lwpr:String!
    let dryy_lwpr_vrss_prpr_rate:String!
    let dryy_lwpr_date:String!
    let w52_hgpr:String!
    let w52_hgpr_vrss_prpr_ctrt:String!
    let w52_hgpr_date:String!
    let w52_lwpr:String!
    let w52_lwpr_vrss_prpr_ctrt:String!
    let w52_lwpr_date:String!
    let whol_loan_rmnd_rate:String!
    let ssts_yn:String!
    let stck_shrn_iscd:String!
    let fcam_cnnm:String!
    let cpfn_cnnm:String!
    let apprch_rate:String!
    let frgn_hldn_qty:String!
    let vi_cls_code:String!
    let ovtm_vi_cls_code:String!
    let last_ssts_cntg_qty:String!
    let invt_caful_yn:String!
    let short_over_yn:String!
    let sltr_yn:String!
    let iscd_stat_cls_code:String! // 종목 상태 코드 -> 00 : 그외, 51 : 관리종목, 52 : 투자의견, 53 : 투자경고, 54 : 투자주의, 55 : 신용가능, 57 : 증거금 100%, 58 : 거래정지, 59 : 단기과열
    let bstp_kor_isnm:String! // 업종
    let stck_prpr:String! // 주식 현재가
    let prdy_vrss_sign:String! // 전일 대비 부호 -> 1 : 상한, 2 : 상승, 3 : 보합, 4 : 하한, 5 : 하락
    let prdy_vrss:String! // 전일 대비
    let prdy_ctrt:String! // 전일 대비율
    let prdy_vrss_vol_rate:String! // 전일 대비 거래량 비율
    let stck_oprc:String! // 주식 시가
    let stck_hgpr:String! // 주식 최고가
    let stck_lwpr:String! // 주식 최저가
    let stck_mxpr:String! // 주식 상한가
    let stck_llam:String! // 주식 하한가
    let stck_sdpr:String! // 주식 기준가
    let wghn_avrg_stck_prc:String! // 가중 평균 주식 가격
    let mrkt_warn_cls_code:String! // 시장 경고 코드 -> 00 : 없음, 01 : 투자주의, 02 : 투자경고, 03 : 투자위험
}

// 주식 현재가 일별
struct InquireDailyPriceResponse:Codable {
    let rt_cd:String?
    let msg_cd:String?
    let msg1:String?
    let output:[InquireDailyPriceResponseOutput]
}

struct InquireDailyPriceResponseOutput:Codable {
    let stck_bsop_date:String! // 주식 영업 일자
    let stck_oprc:String! // 주식 시가
    let stck_hgpr:String! //    주식 최고가
    let stck_lwpr:String! //     주식 최저가
    let stck_clpr:String! //     주식 종가
    let acml_vol:String! //     누적 거래량
    let prdy_vrss_vol_rate:String!//     전일 대비 거래량 비율
    let prdy_vrss:String! //     전일 대비
    let prdy_vrss_sign:String! //     전일 대비 부호        1 : 상한    2 : 상승    3 : 보합    4 : 하한    5 : 하락
    let prdy_ctrt:String!//    전일 대비율
    let hts_frgn_ehrt:String! //     HTS 외국인 소진율
    let frgn_ntby_qty:String! //     외국인 순매수 수량
    let flng_cls_code:String! //     락 구분 코드    01:권리락 02:배당락 03:분배락 04:권배락 05:중간(분기)배당락 06:권리중간배당락     07:권리분기배당락
    let acml_prtt_rate:String! //     누적 분할 비율
}
