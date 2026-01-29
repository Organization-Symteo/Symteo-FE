//
//  CommonResponse.swift
//  Symteo
//
//  Created by 박병선 on 1/29/26.
//

import Foundation

// 최상위 응답 모델
public struct APIResponse<T: Decodable>: Decodable {
    public let isSuccess: Bool
    public let code: String
    public let message: String
    public let result: T?
}

// result가 없는 응답 모델
public struct StatusResponseOnly: Codable {
    public let isSuccess: Bool
    public let code: String
    public let message: String
}

