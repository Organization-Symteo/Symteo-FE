//
//  SessionManager.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//


import SwiftUI
import Combine

final class SessionManager: ObservableObject {
    @AppStorage("isLoggedIn") private var storedIsLoggedIn: Bool = false
    @Published var isLoggedIn: Bool = false

    init() {
        self.isLoggedIn = storedIsLoggedIn
    }

    func login() {
        isLoggedIn = true
        storedIsLoggedIn = true
    }

    func logout() {
        DispatchQueue.main.async {
            self.isLoggedIn = false
            self.storedIsLoggedIn = false
        }
    }
}