//
//  NavigationDestination.swift
//  Symteo
//
//  Created by 김지우 on 1/8/26.
//

import Foundation

enum NavigationDestination: Equatable, Hashable{

    case basetab
    
    
    case depressionTest
    case stressTest
    case typeTest
    
    case survey(kind: SurveyKind)
    
    

    case setting
    case privacy
    case service
    
    case counselsetting



}
