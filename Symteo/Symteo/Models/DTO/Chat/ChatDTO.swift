//
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

// setting 성공 응답이 문자열이라 별도 처리 (requestPlainString)

// MARK: - Send Message (POST)

struct CounselSendResultDTO: Decodable {
    let userId: Int
    let chatRoomId: Int
    let userRequest: String
    let AiResponse: String
}

// MARK: - End Chat (PATCH)

struct CounselEndRequestDTO: Encodable {
    let chatRoomId: Int
}

struct CounselEndResultDTO: Decodable {
    let userId: Int
    let chatRoomId: Int
    let chatSummary: String
    let userSummary: String
    let aiSummary: String
}
