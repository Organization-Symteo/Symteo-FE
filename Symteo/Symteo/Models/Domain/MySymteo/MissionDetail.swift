//
//  MissionDetail.swift
//  Symteo
//
//  Created by 박병선 on 2/7/26.
//
import SwiftUI
import Foundation

struct MissionDetail {
    let id: Int
    let title: String
    let content: String              // draftContents
    let imageURLs: [URL]
    let completedAt: Date
    let isCompleted: Bool
}
