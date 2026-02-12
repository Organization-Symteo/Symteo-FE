//
//  TabItem.swift
//  Symteo
//
//  Created by 김지우 on 1/8/26.
//

enum TabItem: String, CaseIterable{
    
    case home, test, report, chat, profile


    var title: String {
            switch self {
            case .home: return "홈"
            case .test: return "진단"
            case .report: return "리포트"
            case .chat: return "맞춤 상담"
            case .profile: return "My 심터"

            }
        }
    
    var systemIcon: String{
        switch self{
        case .home: return "home"
        case .test: return "test"
        case .report: return "report"
        case .chat: return "chat"
        case .profile: return "profile"
            
        }
    }
    
    var systemIconFill: String{
        switch self{
        case .home: return "homefill"
        case .test: return "testfill"
        case .report: return "reportfill"
        case .chat: return "chatfill"
        case .profile: return "profilefill"

        }
    }
}
