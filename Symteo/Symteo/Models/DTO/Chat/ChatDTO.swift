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
    let counselId: Int64
}

struct CounselEndResultDTO: Decodable {
    let chatRoomId: Int
    let chatSummary: String
    let userSummary: String
    let aiSummary: String
}

// MARK: - Report (GET)

struct CounselReportResultDTO: Decodable {
    let userId: Int
    let chatRoomId: Int
    let userRequest: String
    let AiResponse: String
}
