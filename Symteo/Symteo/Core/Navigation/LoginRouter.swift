//
//  LoginRouter.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import SwiftUI
import Observation
import Combine

final class LoginRouter: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ destination: LoginDestination) {
        path.append(destination)
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func reset() {
        path = NavigationPath()
    }
}
