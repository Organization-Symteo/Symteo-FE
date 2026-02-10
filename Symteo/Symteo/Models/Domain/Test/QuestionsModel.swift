//
//  QuestionsModel.swift
//  Symteo
//
//  Created by 김지우 on 1/25/26.
//

import Foundation

struct QuestionsModel: Identifiable {
    let id: UUID
    let text: String
    let options: [String]
}
