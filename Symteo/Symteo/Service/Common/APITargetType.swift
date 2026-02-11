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

*/

// 임시
extension APITargetType {
    var headers: [String: String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(Config.devToken)"
        ]
    }
    
    var validationType: ValidationType { .none }
}
