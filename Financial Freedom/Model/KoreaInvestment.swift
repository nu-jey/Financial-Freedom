//
//  KoreaInvestment.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/21.
//

import Foundation

class KoreanInvestment {
    private var accessToken:String = ""
    
    func getToken(completionHandler: @escaping (Bool, Any) -> Void) {
        // API - 토큰 발행
        var request = URLRequest(url: URL(string: "https://openapi.koreainvestment.com:9443/oauth2/tokenP")!)
        request.httpMethod = "POST"
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // body
        let body = [
            "grant_type": "client_credentials",
            "appkey": "\(Constant.appKey)",
            "appsecret":"\(Constant.appsecret)"
        ] as [String: Any]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            print("Error creating JSON data")
        }
        
        // 서버에 요청 - 토큰 발행
        let approvalTask = URLSession(configuration: .default).dataTask(with: request) {(data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let output = try? JSONDecoder().decode(TokenResponse.self, from: data!) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            // 반환 받은 토큰 값 저장
            completionHandler(true, output.access_token!)
        }
        approvalTask.resume()
    }
    
    func searchMarket(tokenState:Bool, completionHandler: @escaping (Bool, Any) -> Void) {
        if !tokenState {
            // 토큰이 발급되지 않은 경우
            // API - 토큰 발행
            var request = URLRequest(url: URL(string: "https://openapi.koreainvestment.com:9443/oauth2/tokenP")!)
            request.httpMethod = "POST"
            // header
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // body
            let body = [
                "grant_type": "client_credentials",
                "appkey": "\(Constant.appKey)",
                "appsecret":"\(Constant.appsecret)"
            ] as [String: Any]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
            } catch {
                print("Error creating JSON data")
            }
            
            // 서버에 요청 - 토큰 발행
            let approvalTask = URLSession(configuration: .default).dataTask(with: request) {(data, response, error) in
                // error 체크
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                guard let output = try? JSONDecoder().decode(TokenResponse.self, from: data!) else {
                    print("Error: JSON Data Parsing failed")
                    return
                }
                // 반환 받은 토큰 값 저장
                self.accessToken = output.access_token!
                
                // API - 거래량 순위
                var request = URLRequest(url: URL(string: "https://openapi.koreainvestment.com:9443/uapi/domestic-stock/v1/quotations/volume-rank?FID_COND_MRKT_DIV_CODE=J&FID_COND_SCR_DIV_CODE=20171&FID_INPUT_ISCD=0002&FID_DIV_CLS_CODE=0&FID_BLNG_CLS_CODE=0&FID_TRGT_CLS_CODE=111111111&FID_TRGT_EXLS_CLS_CODE=000000&FID_INPUT_PRICE_1=0&FID_INPUT_PRICE_2=0&FID_VOL_CNT=0&FID_INPUT_DATE_1=0")!)
                request.httpMethod = "Get"
                // header
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "authorization")
                request.setValue("\(Constant.appKey)", forHTTPHeaderField:"appkey")
                request.setValue("\(Constant.appsecret)", forHTTPHeaderField: "appsecret")
                request.setValue("FHPST01710000", forHTTPHeaderField: "tr_id")
                // 서버에 요청 - 거래량 순위
                URLSession.shared.dataTask(with: request) {(data, response, error) in
                    // error 체크
                    if let e = error {
                        print(e.localizedDescription)
                        return
                    }
                    guard let output = try? JSONDecoder().decode(MarketResponse.self, from: data!) else {
                        print("Error: JSON Data Parsing failed")
                        return
                    }
                    if output.rt_cd == "1" {
                        // 요청 실패
                        completionHandler(false, output.msg1!)
                    } else {
                        completionHandler(true, output.output!)
                    }
                }.resume()
            }
            approvalTask.resume()
        } else {
            // 발급된 토큰이 있는 경우
            var request = URLRequest(url: URL(string: "https://openapi.koreainvestment.com:9443/uapi/domestic-stock/v1/quotations/volume-rank?FID_COND_MRKT_DIV_CODE=J&FID_COND_SCR_DIV_CODE=20171&FID_INPUT_ISCD=0002&FID_DIV_CLS_CODE=0&FID_BLNG_CLS_CODE=0&FID_TRGT_CLS_CODE=111111111&FID_TRGT_EXLS_CLS_CODE=000000&FID_INPUT_PRICE_1=0&FID_INPUT_PRICE_2=0&FID_VOL_CNT=0&FID_INPUT_DATE_1=0")!)
            request.httpMethod = "Get"
            // header
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "authorization")
            request.setValue("\(Constant.appKey)", forHTTPHeaderField:"appkey")
            request.setValue("\(Constant.appsecret)", forHTTPHeaderField: "appsecret")
            request.setValue("FHPST01710000", forHTTPHeaderField: "tr_id")
            URLSession.shared.dataTask(with: request) {(data, response, error) in
                // error 체크
                if let e = error {
                    print(e.localizedDescription)
                    return
                }
                
                guard let output = try? JSONDecoder().decode(MarketResponse.self, from: data!) else {
                    print("Error: JSON Data Parsing failed")
                    return
                }
                if output.rt_cd == "1" {
                    // 요청 실패
                    completionHandler(false, output.msg1!)
                } else {
                    completionHandler(true, output.output!)
                }
            }.resume()
        }
    }
    func inquirePrice(fid_cond_mrkt_div_code:String, fid_input_iscd:String, completionHandler: @escaping (Bool, Any) -> Void) {
        // API - 주식 현재가 시세
        var request = URLRequest(url: URL(string: "https://openapi.koreainvestment.com:9443/uapi/domestic-stock/v1/quotations/inquire-price?FID_COND_MRKT_DIV_CODE=\(fid_cond_mrkt_div_code)&FID_INPUT_ISCD=\(fid_input_iscd)")!)
        request.httpMethod = "Get"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "authorization")
        request.setValue("\(Constant.appKey)", forHTTPHeaderField:"appkey")
        request.setValue("\(Constant.appsecret)", forHTTPHeaderField: "appsecret")
        request.setValue("FHKST01010100", forHTTPHeaderField: "tr_id")
        
        // 서버에 요청 - 주식 현재가 시세
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let output = try? JSONDecoder().decode(InquirePriceResponse.self, from: data!) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            if output.rt_cd == "1" {
                // 요청 실패
                completionHandler(false, output.msg1!)
            } else {
                completionHandler(true, output.output)
            }
        }.resume()
    }
    
    func inquireDailyPrice(fid_cond_mrkt_div_code:String, fid_input_iscd:String, fid_period_div_code:String, fid_org_adj_prc:String, completionHandler: @escaping (Bool, Any) -> Void) {
        // API - 주식 현재가 일자별
        var request = URLRequest(url: URL(string:"https://openapi.koreainvestment.com:9443/uapi/domestic-stock/v1/quotations/inquire-daily-price?fid_cond_mrkt_div_code=\(fid_cond_mrkt_div_code)&fid_input_iscd=\(fid_input_iscd)&fid_period_div_code=\(fid_period_div_code)&fid_org_adj_prc=\(fid_org_adj_prc)")!)
        request.httpMethod = "Get"
        
        // header
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.accessToken)", forHTTPHeaderField: "authorization")
        request.setValue("\(Constant.appKey)", forHTTPHeaderField:"appkey")
        request.setValue("\(Constant.appsecret)", forHTTPHeaderField: "appsecret")
        request.setValue("FHKST01010400", forHTTPHeaderField: "tr_id")
        
        // 서버에 요청 - 주식 현재가 일자별
        URLSession.shared.dataTask(with: request) {(data, response, error) in
            // error 체크
            if let e = error {
                print(e.localizedDescription)
                return
            }
            guard let output = try? JSONDecoder().decode(InquireDailyPriceResponse.self, from: data!) else {
                print("Error: JSON Data Parsing failed")
                return
            }
            if output.rt_cd == "1" {
                // 요청 실패
                completionHandler(false, output.msg1!)
            } else {
                completionHandler(true, output.output)
            }
        }.resume()
    }
}


enum KRChartStateType {
    case up
    case upRight
    case right
    case downRight
    case down
    case unknown
}

struct KRChartState {
    var state: KRChartStateType
    var image: String {
        switch self.state {
        case .up:
            return "arrow.up.to.line"
        case .upRight:
            return "arrow.up.right.square"
        case .right:
            return "arrow.right.square"
        case .downRight:
            return "arrow.down.right.square"
        case .down:
            return "arrow.down.to.line"
        case .unknown:
            return "questionmark.square"
        }
    }
}
