//
//  SurveyKind.swift
//  Symteo
//
//  Created by 김지우 on 2/11/26.
//

import Foundation


enum SurveyKind: String, Hashable, Codable {
    case stress
    case depression
    case attachment
    
    func reportDestination(reportId: Int) -> NavigationDestination {
            switch self {
            case .depression:
                return .anxietyReport(reportId: reportId)

            case .stress:
                return .stressReport(reportId: reportId)

            case .attachment:
                return .attachmentReport(reportId: reportId)
            }
        }
}
