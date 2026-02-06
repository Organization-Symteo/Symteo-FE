//
//  TabItem.swift
//  Symteo
//
//  Created by 김지우 on 1/8/26.
//

enum TabItem: String, CaseIterable{
    
    case home, chat, report, test, profile


    var title: String {
            switch self {
            case .home: return "홈"
            case .chat: return "진단"
            case .report: return "리포트"
            case .test: return "맞춤 상담"
            case .profile: return "My 심터"

            }
        }
    
    var systemIcon: String{
        switch self{
        case .home: return "home"
        case .chat: return "test"
        case .report: return "report"
        case .test: return "chat"
        case .profile: return "profile"
            
        }
    }
    
    var systemIconFill: String{
        switch self{
        case .home: return "home_fill"
        case .chat: return "test_fill"
        case .report: return "report_fill"
        case .test: return "chat_fill"
        case .profile: return "profile_fill"

        }
    }
}
