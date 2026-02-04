//
//  CounselSettingViewModel.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import Foundation
import SwiftUI
import Combine

class CounselSettingViewModel: ObservableObject {
    
    // MARK: - 1. 데이터 정의 (텍스트 데이터)
    // 뷰는 이 배열만 바라보고 화면을 그립니다.
    @Published var sections: [CounselSection] = [
        CounselSection(title: "대화 분위기", options: ["친근함", "따뜻함", "차분함"], isMultiSelect: true),
        CounselSection(title: "도움방식", options: ["공감 & 경청형", "해결 & 조언형", "팩트형"], isMultiSelect: true),
        CounselSection(title: "역할", options: ["상담사", "친구", "멘탈 코치"], isMultiSelect: true),
        CounselSection(title: "답변형식", options: ["짧고 간결", "길고 자세히", "상황에 맞게"], isMultiSelect: true),
        CounselSection(title: "말투", options: ["존댓말", "반말"], isMultiSelect: false) // 여기만 단일 선택
    ]
    
    // MARK: - 2. 선택 상태 관리 (Dictionary 사용)
    // Key: 섹션 제목, Value: 선택된 옵션들의 집합(Set)
    @Published var selections: [String: Set<String>] = [
        "대화 분위기": ["친근함"],
        "도움방식": ["공감 & 경청형"],
        "역할": ["상담사"],
        "답변형식": ["짧고 간결"],
        "말투": ["존댓말"]
    ]
    
    // MARK: - 3. 로직 (통합 토글 함수)
    func toggleOption(sectionTitle: String, option: String, isMultiSelect: Bool) {
        var currentSet = selections[sectionTitle] ?? []
        
        if isMultiSelect {
            // 다중 선택: 있으면 빼고, 없으면 넣음
            if currentSet.contains(option) {
                currentSet.remove(option)
            } else {
                currentSet.insert(option)
            }
        } else {
            // 단일 선택 (말투): 기존꺼 다 지우고 새로 선택한 것만 넣음
            currentSet.removeAll()
            currentSet.insert(option)
        }
        
        selections[sectionTitle] = currentSet
    }
    
    // 선택 여부 확인 헬퍼
    func isSelected(sectionTitle: String, option: String) -> Bool {
        return selections[sectionTitle]?.contains(option) ?? false
    }
    
    func saveSettings() {
        print("최종 선택 데이터: \(selections)")
    }
}
