//
//  APITargetType.swift
//  Symteo
//
//  Created by 박병선 on 1/29/26.
//
import Foundation
import Moya

protocol APITargetType: TargetType {}
/*
extension APITargetType {

    
    var headers: [String: String]? {
        switch task {
        case .requestJSONEncodable, .requestParameters:
            return ["Content-Type": "application/json"]
        case .uploadMultipart:
            return ["Content-Type": "multipart/form-data"]
        default:
            return nil
        }
    }
    
    var validationType: ValidationType { .none }
         
}
 let devToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzcwNzM5MjU1LCJleHAiOjE3NzA4MjU2NTV9.koiL8HFI3wZjaf6NAUoBfBTLa2x0Q8KbcDXztkTwwG0"
*/


extension APITargetType {
    var headers: [String: String]? {
        print("🔥🔥🔥 headers CALLED 🔥🔥🔥")
        var headers: [String: String] = [:]

        headers["Content-Type"] = "application/json"

        // TokenProvider를 통해 토큰을 가져옵니다.
        // DEBUG 모드면 하드코딩된 토큰이, 아니면 키체인 토큰이 자동으로 반환됩니다.
        let token = TokenProvider().accessToken ?? ""
        
        if !token.isEmpty {
            headers["Authorization"] = "Bearer \(token)"
        }

        if case .uploadMultipart = task {
            headers["Content-Type"] = "multipart/form-data"
        }

        print("🔥 Authorization =", headers["Authorization"] ?? "nil")
        return headers
    }
}
