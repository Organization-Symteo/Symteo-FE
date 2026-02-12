//
//  SymteoApp.swift
//  Symteo
//
//  Created by 김지우 on 1/6/26.
//

import SwiftUI
import KakaoSDKCommon

@main
struct SymteoApp: App {
    
    @StateObject private var container: DIContainer = .init()
    @StateObject private var sessionManager = SessionManager()


    init() {
        guard let appKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String else {
            fatalError("KAKAO_NATIVE_APP_KEY not found")
        }

        KakaoSDK.initSDK(appKey: appKey)
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(container)
                .environmentObject(sessionManager)
            
        }
    }
}
