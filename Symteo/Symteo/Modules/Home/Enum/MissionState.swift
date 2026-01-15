//
//  MissionStep.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
// 화면의 미션 상태를 관리하는 Enum 입니다.

import Foundation

enum MissionState {
    case arrived    // 미션 도착
    case confirmed  // 미션 확인
    case writing    // 미션 수행
    case completed  // 미션 완료
}
