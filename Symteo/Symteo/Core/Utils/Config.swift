//
//  Config.swift
//  Symteo
//
import Foundation


enum Config {

    static var baseUrl: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
        else {
            fatalError("BASE_URL not found in Info.plist")
        }
        return value
    }

    static var kakaoKey: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "KAKAO_KEY") as? String
        else {
            fatalError("KAKAO_KEY not found in Info.plist")
        }
        return value
    }
    
    // 임시 dev-Token
        static let devToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzcwNzgzNzYzLCJleHAiOjE3NzA4NzAxNjN9.Ulx9ipmNgxGdP-HR4kwg1BsCZCeW8dwdQ357Zp9kh2g"
}
