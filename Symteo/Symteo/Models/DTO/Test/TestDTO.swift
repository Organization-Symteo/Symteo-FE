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
    
    struct CreateTestResponseDTO: Decodable {
        let testId: Int
        let value: JSONValueDTO?
    }
    
    enum JSONValueDTO: Decodable, Hashable {
        case string(String)
        case int(Int)
        case double(Double)
        case bool(Bool)
        case object([String: JSONValueDTO])
        case array([JSONValueDTO])
        case null
        
        init(from decoder: Decoder) throws {
            let c = try decoder.singleValueContainer()
            if c.decodeNil() { self = .null; return }
            if let v = try? c.decode(Bool.self) { self = .bool(v); return }
            if let v = try? c.decode(Int.self) { self = .int(v); return }
            if let v = try? c.decode(Double.self) { self = .double(v); return }
            if let v = try? c.decode(String.self) { self = .string(v); return }
            if let v = try? c.decode([String: JSONValueDTO].self) { self = .object(v); return }
            if let v = try? c.decode([JSONValueDTO].self) { self = .array(v); return }
            throw DecodingError.typeMismatch(
                JSONValueDTO.self,
                .init(codingPath: decoder.codingPath, debugDescription: "Unsupported JSON type")
            )
        }
    }

    let testId: Int

}
