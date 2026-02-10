//
//  TestModel.swift
//  Symteo
//
//  Created by 김지우 on 1/13/26.
//

import Foundation

struct TestModel: Identifiable{
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let testtime: String
}
