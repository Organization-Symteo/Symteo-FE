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
