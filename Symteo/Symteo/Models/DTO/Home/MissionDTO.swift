//
//  MissionDTO.swift
//  Symteo
//
//  Created by 박병선 on 2/3/26.
//
import Foundation

// MARK: -미션 요청/응답
/// 오늘의 미션 Response
struct TodayMissionResult: Codable {
        let contents: String
        let remainingSeconds: Int
        let restarted: Bool
    }
    //typealias TodayMissionResponse = BaseResponse<TodayMissionResult>

/// 미션 시작 Request
struct MissionStartRequest: Codable {
    let content: String
    let imageUrl: String
}

///미션 시작 Response
struct MissionStartResult: Codable {
    let userMissionId: Int
    let remainingSeconds: Int
    let completed: Bool
    let drafted: Bool
}

/// 미션 텍스트 제출 Request
struct MissionDraftRequest: Codable {
    let contents: String
}

/// 미션 텍스트 제출 Response
struct MissionDraftResult: Codable {
    let draftId: Int?
    let updatedAt: String?
    let drafted: Bool
}
