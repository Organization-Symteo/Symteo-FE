//
//  SymteoApp.swift
//  Symteo
//
//  Created by 김지우 on 1/6/26.
//

import SwiftUI

@main
struct SymteoApp: App {
    
    @StateObject private var container: DIContainer = .init()
    @StateObject private var sessionManager = SessionManager()



    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(container)
                .environmentObject(sessionManager)
            
        }
    }
}
