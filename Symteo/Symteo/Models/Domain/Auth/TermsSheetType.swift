//
//  TermsSheetType.swift
//  Symteo
//
//  Created by 김지우 on 1/15/26.
//

import Foundation

enum TermsSheetType: Identifiable {
    case safeTerms      // 안심 이용약관
    case dataConsent    // 데이터 처리 동의

    var id: Int { hashValue }

    var title: String {
        switch self {
        case .safeTerms: return "서비스 약관 및 정책"
        case .dataConsent: return "개인정보 처리방침"
        }
    }
}
