//
//  ReportStatus.swift
//  Symteo
//
//  Created by 박병선 on 2/9/26.
//
//  레포트 상태 분기
enum ReportStatus {
    case none          // 리포트 없음
    case loading       // 생성 중
    case available(Int) // 생성된 리포트 있음
    case error // 에러 발생
}
