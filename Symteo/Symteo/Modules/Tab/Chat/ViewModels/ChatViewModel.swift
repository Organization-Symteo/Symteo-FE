//
//  ChatViewModel.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//

import Foundation
import Combine
import Moya

@MainActor
class ChatViewModel: ObservableObject {
    
    // MARK: - 메시지
    
    /// 화면에 띄울 메시지 목록
    @Published var messages: [ChatMessage] = []
    
    /// 페이지네이션을 위해, 마지막 메시지의 createdAt 저장
    @Published var lastCreateAt: String? = nil
    
    /// postChat 함수가 로딩 중임을 나타냄
    @Published var isPostingChat: Bool = false
    
    /// getLatestChat, deleteChats 함수가 로딩 중임을 나타냄
    @Published var isFetchingChats: Bool = false
    
    /// 메시지 페이지네이션에서 다음 페이지가 있는지 나타냄
    @Published var hasNext: Bool = true
    
    // 스크롤 트리거
    @Published var shouldScrollToBottom = false
    
    // MARK: - 의존성 주입 및 비동기 처리
    
    /// DIContainer를 통해 의존성 주입
    let container: DIContainer
    /// Combine 구독 해제를 위한 Set
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - 사용자 입력
    
    /// 입력된 채팅 본문
    @Published var textInput = ""
    
    // MARK: - 초기화
    
    init(container: DIContainer) {
        self.container = container
    }
    
    // MARK: - 함수
    
    public func sendMessage() async {
        let text = textInput
        self.textInput = ""
        
        let newMessage = ChatMessage(
            role: .user,
            content: text,
            createdAt: Date().isoYearMonthDayHourMinuteString
        )
        messages.append(newMessage)
    }
    
    
    // MARK: - API
    
    /// 채팅 요청 함수 작성 예정
    
    /// 이전 대화 기록 조회에서, 커서 페이징 함수 작성 예정
    
    // 채팅 기록 초기화 함수 작성 예정
}

// MARK: - 보내는 메시지를 띄우기 위한 날짜 변환 함수

extension Date {
    var isoYearMonthDayHourMinuteString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}
