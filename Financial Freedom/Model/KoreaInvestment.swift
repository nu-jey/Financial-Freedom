//
//  KoreaInvestment.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/21.
//

import Foundation

struct KoreanInvestment {
    func Approval() {
        var request = URLRequest(url: URL(string: "https://openapivts.koreainvestment.com:29443/oauth2/tokenP")!)
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
        
        // 서버에 요청
        URLSession.shared.dataTask(with: request) {(data, response, error) in
              // error 체크
              if let e = error {
                  print(e.localizedDescription)
                  return
              }
              
              print("response=\(response)")
              
              DispatchQueue.main.async {
                  do{
                      let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                      guard let jsonObj = json else {return}
                      
                      let result = jsonObj["result"] as? String
                      let id = jsonObj["userId"] as? String
                      let name = jsonObj["name"] as? String
                      
                      if result == "SUCCESS" {
                          // data 확인
                          print("결과==>\(String(data: data!, encoding: .utf8)!)")
                      }
                  } catch let e as NSError {print(e.localizedDescription)}
              }
          }.resume() // resume()을 해야 전송이 됨 : URLSession.shared.dataTask(...)객체
        
    }
}
