//
//  ReportService.swift
//  Symteo
//
//  Created by 박병선 on 2/8/26.
//
/*
import Foundation
import CombineMoya
import Moya
import Combine

protocol ReportServiceProtocol {

    /// 우울/불안 리포트 생성
    func createDepressionAnxietyReport(diagnoseId: Int) -> AnyPublisher<DepressionAnxietyReportResult, APIError>
    
    /// 우울·불안 리포트 상세 조회
    func getDepressionAnxietyReport(reportId: Int) -> AnyPublisher<DepressionAnxietyReportDetail, APIError>
    
    /// 스트레스 리포트 생성
    func creatStressReport(diagnoseId: Int) -> AnyPublisher<StressReportResult, APIError>
    
    /// 스트레스 리포트 조회
    func getStressReport(reportId: Int) -> AnyPublisher<StressReportDetail, APIError>
    
    /// 애착 리포트 생성
    func CreatAttachmentReport(diagnoseId: Int) -> AnyPublisher<AttachmentReportCreateResult, APIError>
    
    /// 애착 리포트 조회
}


final class ReportService: ReportServiceProtocol {

    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<ReportRouter>

    // MARK: - Initializer

    init(provider: MoyaProvider<ReportRouter> = APIManager.shared.createProvider(for: ReportRouter.self)){
        self.provider = provider
    }

    // MARK: - 우울/불안 리포트 생성
    func createDepressionAnxietyReport(diagnoseId: Int) -> AnyPublisher<DepressionAnxietyReportResult, APIError> {
        return provider.requestResult(.createDepressionAnxietyReport(diagnoseId: diagnoseId),type: DepressionAnxietyReportResult.self)
    }
    
    //MARK: - 우울/불안 리포트 조회
    func getDepressionAnxietyReport(reportId: Int) -> AnyPublisher<DepressionAnxietyReportDetail, APIError> {
        return provider.requestResult(.getDepressionAnxietyReport(reportId: reportId),type: DepressionAnxietyReportDetail.self)
    }
    
    // MARK: - 스트레스 리포트 생성
       func creatStressReport(diagnoseId: Int) -> AnyPublisher<StressReportResult, APIError> {
           return provider.requestResult(.creatStressReport(diagnoseId: diagnoseId),type: StressReportResult.self)
    }
    
    // MARK: -스트레스 리포트 조회
    func getStressReport(reportId: Int) -> AnyPublisher<StressReportDetail, APIError> {
        return provider.requestResult(.getStressReport(reportId: reportId),type: StressReportDetail.self)
    }
    
    // MARK: - 애착검사 리포트 생성
    func CreatAttachmentReport(diagnoseId: Int) -> AnyPublisher<AttachmentReportCreateResult, APIError> {
        return provider.requestResult(.creatAttachmentReport(diagnoseId: diagnoseId),type: AttachmentReportCreateResult.self)
    }
}
*/

