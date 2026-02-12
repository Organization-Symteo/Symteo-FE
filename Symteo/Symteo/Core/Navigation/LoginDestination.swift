//
//  LoginDestination.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import Foundation

enum LoginDestination: Hashable {
    case permit
    case policy(num: Int)
    case nickname
}
