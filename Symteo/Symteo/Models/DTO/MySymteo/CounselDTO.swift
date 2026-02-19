//
//  CounselDTO.swift
//  Symteo
//
//  Created by 김지우 on 2/19/26.
//
 
import Foundation

// MARK: - 전체 상담 기록(채팅방 목록) 아이템
public struct CounselRecordItemDTO: Decodable, Hashable, Sendable {
    public let dateTime: String
    public let chatSummary: String?
    public let chatRoomId: Int
}

// MARK: - 상담 요약(상담 결과) 상세 조회
public struct CounselSummaryResultDTO: Decodable, Hashable, Sendable {
    public let userId: Int
    public let chatRoomId: Int
    public let chatSummary: String?
    public let userSummary: String?
    public let aiSummary: String?
}
