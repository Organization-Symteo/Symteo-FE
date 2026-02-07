//
//  MissionMode.swift
//  Symteo
//
//  Created by 박병선 on 2/6/26.
//

enum MissionMode {
    case read(record: MissionList)        //  과거 미션 기록 조회
    case edit(record: MissionList)        //  과거 미션 기록 수정
}
