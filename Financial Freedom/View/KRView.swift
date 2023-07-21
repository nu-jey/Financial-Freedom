//
//  KRView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/16.
//

import SwiftUI

struct KRView: View {
    var ki = KoreanInvestment()
    var body: some View {
        Button("토큰 생성") {
            ki.Approval()
        }
    }
    
}

struct KRView_Previews: PreviewProvider {
    static var previews: some View {
        KRView()
    }
}
