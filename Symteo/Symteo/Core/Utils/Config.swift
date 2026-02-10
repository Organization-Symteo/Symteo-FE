//
//  Config.swift
//  Symteo
//
//  Created by 박병선 on 2/6/26.
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
}
