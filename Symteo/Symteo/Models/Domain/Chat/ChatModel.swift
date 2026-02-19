//
//  ChatMode.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//
import Foundation

enum ChatRole: Equatable {
    case user
    case model
}

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    var role: ChatRole
    var content: String
    var createdAt: String

    init(
        id: UUID = UUID(),
        role: ChatRole,
        content: String,
        createdAt: String = Date().isoYearMonthDayHourMinuteString
    ) {
        self.id = id
        self.role = role
        self.content = content
        self.createdAt = createdAt
    }

    static func user(_ text: String) -> ChatMessage {
        .init(role: .user, content: text)
    }

    static func model(_ text: String) -> ChatMessage {
        .init(role: .model, content: text)
    }
}

extension Date {
    var isoYearMonthDayHourMinuteString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }

    var yearMonthDayKoreanString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}


//상담기록
struct CounselingRecord: Identifiable, Equatable {
    var id: Int { counselId }

    let counselId: Int
    let date: String
    let title: String
    let userContent: String
    let aiResponse: String

    // 목록용 매핑 (chatSummary는 null 가능)
    static func fromListDTO(_ dto: CounselHistoryItemDTO) -> CounselingRecord {
        .init(
            counselId: dto.counselId,
            date: dto.dateTime,
            title: dto.chatSummary ?? "상담 기록",
            userContent: "",   // 목록에서는 없음
            aiResponse: ""     // 목록에서는 없음
        )
    }

    // 상세용 매핑
    static func fromDetailDTO(_ dto: CounselHistoryDetailDTO, dateTime: String? = nil) -> CounselingRecord {
        .init(
            counselId: dto.chatRoomId,
            date: dateTime ?? "", // 목록에서 넘어온 date를 유지하고 싶으면 주입
            title: dto.chatSummary,
            userContent: dto.userSummary,
            aiResponse: dto.aiSummary
        )
    }
}
