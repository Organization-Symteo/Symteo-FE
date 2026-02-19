//  ChatDTO.swift
//  Symteo
//
//  Created by 김지우 on 2/1/26.
//

import Foundation

// MARK: - Setting

struct CounselSettingRequestDTO: Encodable {
    let atmosphere: String?
    let supportStyle: String?
    let roleCounselor: String?
    let answerFormat: String?
    let tone: String?
}

struct CounselSettingResultDTO: Decodable {
    let atmosphere: String?
    let supportStyle: String?
    let roleCounselor: String?
    let answerFormat: String?
    let tone: String?
}

// MARK: - Send Message (POST)

struct CounselSendResultDTO: Decodable {
    let userId: Int
    let chatRoomId: Int
    let userRequest: String
    let AiResponse: String
}

// MARK: - End Chat (PATCH)

struct CounselEndRequestDTO: Encodable {
    let chatRoomId: Int64
}

struct CounselEndResultDTO: Decodable {
    let chatRoomId: Int
    let chatSummary: String
    let userSummary: String
    let aiSummary: String
}



// MARK: - Report (POST)

struct CounselReportRequestDTO: Encodable{
    let chatRoomId: Int?
    let reportType: String
    let reportId: Int
}
struct CounselReportResultDTO: Decodable {
    let chatRoomId: Int
    let userRequest: String
    let AiResponse: String
}



// 전체 상담 조회(GET) - result item
struct CounselHistoryItemDTO: Decodable, Identifiable {
    var id: Int { counselId }

    let dateTime: String
    let chatSummary: String?
    let counselId: Int
}

// 단일 상담 조회(GET) - result
struct CounselHistoryDetailDTO: Decodable {
    let userId: Int
    let chatRoomId: Int
    let chatSummary: String
    let userSummary: String
    let aiSummary: String
}

// 삭제(DELETE) - result(Int: 삭제된 chatRoomId)
typealias CounselDeleteResultDTO = Int
