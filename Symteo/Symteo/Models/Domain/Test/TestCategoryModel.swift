//
//  TestCategoryModel.swift
//  Symteo
//
//  Created by 김지우 on 1/18/26.
//

import Foundation

struct TestCategoryModel: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let themeColor: String
    let mainImage: String
    let infoText: String
    let startButtonTitle: String
    let caution: String
    let questions: [String]
    let emojis: [String]
    let recommendations: [Recommendation]
}


struct Recommendation: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let destination: NavigationDestination
}
