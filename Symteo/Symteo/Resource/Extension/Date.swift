//
//  Date.swift
//  Symteo
//
//  Created by 박병선 on 2/8/26.
//
import Foundation


extension Date {

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: self)
    }
}
