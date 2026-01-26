//
//  AttachmentBar.swift
//  Symteo
//
//  Created by 박병선 on 1/26/26.
//
import Foundation
import SwiftUI


struct AttachmentBarResult {
    let score: Int  
    let ratio: Double
    let level: AttachmentBarLevel
    let metric: AttachmentMetricType
   

    var color: Color { level.color }
    var title: String { level.title }
    var description: String {
        level.description(for: metric)
    }
}
