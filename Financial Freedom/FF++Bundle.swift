//
//  FF++Bundle.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/09/07.
//

import Foundation

extension Bundle {
    var appKey: String? {
        guard let file = self.path(forResource: "APIKey", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["appKey"] as? String else { fatalError("error")}
        return key
    }
    
    var appsecret: String? {
        guard let file = self.path(forResource: "APIKey", ofType: "plist") else { return "" }
        guard let resource = NSDictionary(contentsOfFile: file) else { return "" }
        guard let key = resource["appsecret"] as? String else { fatalError("error")}
        return key
    }
}
