//
//  SessionManager.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//


import SwiftUI
import Combine


@MainActor
final class SessionManager: ObservableObject {

    @AppStorage("isLoggedIn") private var storedIsLoggedIn: Bool = false
    @Published var isLoggedIn: Bool = false

    init() {
        self.isLoggedIn = storedIsLoggedIn
    }

    func setLoggedIn(_ value: Bool) {
        isLoggedIn = value
        storedIsLoggedIn = value
    }

    func logout() {
        setLoggedIn(false)
    }
}
