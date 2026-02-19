//
//  TestDTO.swift
//  Symteo
//
//  Created by 김지우 on 2/10/26.
//
import Foundation

enum TestType: String, Codable {
    case stressBurnoutComplex = "STRESS_BURNOUT_COMPLEX"
    case depressionAnxietyComplex = "DEPRESSION_ANXIETY_COMPLEX"
    case attachmentTest = "ATTACHMENT"
}

struct CreateTestRequestDTO: Encodable {
    let testType: String
    let answers: [CreateTestAnswerDTO]
}

struct CreateTestAnswerDTO: Encodable, Decodable, Hashable {
    let questionNo: Int
    let score: Int
}


struct CreateDiagnosisResultDTO: Decodable {

    let diagnoseId: Int
    

}
