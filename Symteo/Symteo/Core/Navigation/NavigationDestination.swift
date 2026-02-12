//
//  NavigationDestination.swift
//  Symteo
//
//  Created by 김지우 on 1/8/26.
//

import Foundation

enum NavigationDestination: Equatable, Hashable{

    case basetab
    
    // 진단
    case depressionTest /// 우울& 불안 검사 홈
    case stressTest /// 스트레스 검사 홈
    case typeTest ///애착(성향) 검사 홈
    case survey(kind: SurveyKind) /// 설문(실제 진단)
    
    // 리포트
    case anxietyReport(reportId: Int) /// 우울&불안 리포트
    case stressReport(reportId: Int) /// 스트레스 리포트
    case attachmentReport(reportId: Int) /// 성향 리포트
    

    // 마이심터
    case setting
    case privacy
    case service


}
