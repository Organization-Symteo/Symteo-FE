//
//  ChatDTO.swift
//  Symteo
//
//  Created by 김지우 on 2/1/26.
//

import Foundation

/// 챗봇 채팅 요청 구조체
struct ChatRequest: Codable {
    let content: String
}

/// 챗봇 채팅장 조회 응답 구조체
struct ChatResponse: Codable {
    let content: String
    let createdAt: String
    let isMember: Bool
}

struct ChatResult: Codable {
    let hasNext: Bool
    let nextCursor: String?
    let chatsDetatilList: [ChatResponse]
}
