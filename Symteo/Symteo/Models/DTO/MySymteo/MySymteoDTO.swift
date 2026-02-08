//
//  MySymteoDTO.swift
//  Symteo
//
//  Created by 박병선 on 2/7/26.
//
import SwiftUI

// 오늘의 미션 리스트 조회
/// 최상위 응답
struct MissionHistoryResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MissionHistoryResultDTO
}

///result 내부 DTO
struct MissionHistoryResultDTO: Decodable {
    let missions: [MissionHistoryItemDTO]
}

/// 미션리스트 아이템 DTO
struct MissionHistoryItemDTO: Decodable, Identifiable {
    let userMissionId: Int
    let missionContents: String
    let completedAt: String
    let hasImage: Bool

    var id: Int { userMissionId }
}

/// DATE 변환용 computed property
extension MissionHistoryItemDTO {

    var completedDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: completedAt)
    }

    var formattedDate: String {
        guard let date = completedDate else { return "" }

        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
    
    ///DTO -> Domain Model 변환
    func toDomain() -> MissionList {
        MissionList(
                id: userMissionId,
                title: missionContents,
                completedAt: completedDate ?? Date(),
                hasImage: hasImage
        )
    }
}

// MissionDetail용 DTO
/// 최상위 응답
struct MissionDetailResponseDTO: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: MissionDetailResultDTO
}

///result DTO
struct MissionDetailResultDTO: Decodable {
    let userMissionId: Int
    let missionContents: String
    let draftContents: String
    let imageUrls: [String]
    let completedAt: String
    let isCompleted: Bool
}

///날짜 변환
extension MissionDetailResultDTO {
    var completedDate: Date? {
        ISO8601DateFormatter().date(from: completedAt)
    }
}

/// DTO ->  Domain 변환 Mapper
extension MissionDetailResultDTO {
    func toDomain() -> MissionDetail {
        MissionDetail(
            id: userMissionId,
            title: missionContents,
            content: draftContents,
            imageURLs: imageUrls.compactMap { URL(string: $0) },
            completedAt: completedDate ?? Date(),
            isCompleted: isCompleted
        )
    }
}
