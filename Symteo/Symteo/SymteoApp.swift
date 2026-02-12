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
    @StateObject private var container = DIContainer()
    @StateObject private var sessionManager = SessionManager(keychain: .shared)
    
    init() {
        if let appKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String {
            KakaoSDK.initSDK(appKey: appKey)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(container)
                .environmentObject(sessionManager)
        }
    }
}
