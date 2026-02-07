//
//  MissionRecordItem.swift
//  Symteo
//
//  Created by 박병선 on 2/6/26.
//
import Foundation
import SwiftUI

// MissionRecordListView / MissionRecordCell 전용
struct MissionList: Identifiable {
    let id: Int                 // userMissionId
    let title: String           // missionContents
    let completedAt: Date
    let hasImage: Bool          // 사진 유무
}
