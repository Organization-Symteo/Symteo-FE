//
//  Config.swift
//  Symteo
//
import Foundation


enum Config {

    static var baseUrl: String {

            fatalError("BASE_URL not found in Info.plist")
        }
        return value
    }

    static var kakaoKey: String {

        guard let value = Bundle.main.object(forInfoDictionaryKey: "KAKAO_KEY") as? String else {
            fatalError("KAKAO_KEY not found in Info.plist")

        guard let value = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String
        else {
            fatalError("BASE_URL not found in Info.plist")

        }
        return value
    }


    static var devToken: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "DEV_TOKEN") as? String else {
            return ""

    static var kakaoKey: String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: "KAKAO_KEY") as? String
        else {
            fatalError("KAKAO_KEY not found in Info.plist")


        }
        return value
    }
}
