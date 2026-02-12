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
        let bundleId = Bundle.main.bundleIdentifier ?? "nil"
        let appKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_NATIVE_APP_KEY") as? String

        print("bundleId =", bundleId)
        print("kakaoKey =", appKey ?? "nil")

        if let appKey {
            KakaoSDK.initSDK(appKey: appKey)
        } else {
            assertionFailure("KAKAO_NATIVE_APP_KEY is missing in Info.plist")
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
