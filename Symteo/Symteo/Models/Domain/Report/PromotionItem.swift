//
//  PromotionItem.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//
import Foundation

struct PromotionItem: Identifiable {
    let id = UUID()
    let imageName: String
    let type: PromotionType
}
