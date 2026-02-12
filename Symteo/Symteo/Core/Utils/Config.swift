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

/*
    static var devToken: String {
        // If DEV_TOKEN is optional in some builds, return empty string when missing.
        // Adjust this behavior if you prefer a fatalError instead.
        guard let value = Bundle.main.object(forInfoDictionaryKey: "DEV_TOKEN") as? String else {
            return ""

        }
        return value
    }
    */
        
    // 임시 dev-Token
        static let devToken =
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzcwODExNzU0LCJleHAiOjE3NzA4OTgxNTR9.yTpWQldJNzkOcyadrtnt8xS_dDG6qtxFtAYwq3-Tgus"
}
