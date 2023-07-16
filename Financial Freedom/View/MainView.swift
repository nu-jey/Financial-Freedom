//
//  MainView.swift
//  Financial Freedom
//
//  Created by 오예준 on 2023/07/16.
//

import SwiftUI

struct MainView: View {
    @State private var selection = 0
    let title = ["Upbit", "US Trade Market", "KR Trade Market"]
    var body: some View {
        NavigationView {
            TabView(selection: $selection){
                CryptocurrencyView()
                    .tabItem {
                        Image(systemName: "c.square.fill")
                        Text("Crypto")
                    }
                    .tag(0)
                USView()
                    .tabItem {
                        Image(systemName: "u.square.fill")
                        Text("US")
                    }
                    .tag(1)
                KRView()
                    .tabItem {
                        Image(systemName: "k.square.fill")
                        Text("KR")
                    }
                    .tag(2)
            }
            .navigationTitle(title[selection])
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
