//
//  CounselSettingModel.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import Foundation

struct CounselSection: Identifiable {
    let id = UUID()
    let title: String       // 섹션 제목
    let options: [String]   // 선택지 목록 
    let isMultiSelect: Bool // 다중 선택 가능 여부 (말투는 false, 나머지는 true)
}
