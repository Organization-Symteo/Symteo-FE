//
//  AttachmentViewModel.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import SwiftUI
import Foundation
import Combine


// 이 파일에 있는 API 함수 : getAttachmentReport()

final class AttachmentReportViewModel: ObservableObject {
    // MARK: - UI State
    @Published var isLoading: Bool = false
    @Published var errorToast: CustomToast?
    
    // MARK: - Raw DTO
    @Published private(set) var report: AttachmentReportDetail?

    // MARK: - Identity
    let reportId: Int

    // MARK: - Dependency
    private let container: DIContainer
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Init
    init(
        reportId: Int,
        container: DIContainer
    ) {
        self.reportId = reportId
        self.container = container
    }



// MARK: - Header

    var userName: String {
        report?.userName ?? ""
        
    }

    var attachmentType: AttachmentType? {
        guard let value = report?.attachmentType else { return nil }
        return AttachmentType.from(serverValue: value)
    }
    
    var description: String {
            report?.aiFullContent ?? ""
        }

       // MARK: - Bar Results (❗ 서버값 그대로)
       var anxietyResult: AttachmentBarResult? {// 애착 불안 결과
           guard let anxiety = report?.anxiety else { return nil }

           return AttachmentBarResult(
               score: Int(anxiety.score),
               ratio: Double(anxiety.percentage) / 100.0,
               level: AttachmentBarLevel.fromServer(
                   label: anxiety.stateLabel
               ),
               metric: .anxiety
           )
       }

       var avoidanceResult: AttachmentBarResult? {
           guard let avoidance = report?.avoidance else { return nil }

           return AttachmentBarResult(
               score: Int(avoidance.score),
               ratio: Double(avoidance.percentage) / 100.0,
               level: AttachmentBarLevel.fromServer(
                   label: avoidance.stateLabel
               ),
               metric: .avoidance
           )
       }

       // MARK: - Text Sections
       var stressPoints: [PointItem] {
           report?.stressPoints ?? []
       }

       var strengthPoints: [PointItem] {
           report?.strengthPoints ?? []
       }

       var aiDescription: String {
           report?.aiFullContent ?? ""
       }

       var actionGuide: String {
           report?.actionGuideSentence ?? ""
       }
   
    // MARK: - API
    func getAttachmentReport() {
        report = nil
        isLoading = true
        

        container.useCaseService.reportService
            .getAttachmentReport(reportId: reportId)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false

                    if case .failure(let failure) = completion {
                        self?.errorToast = CustomToast(
                            title: "조회 실패",
                            message: failure.errorDescription ?? "리포트를 불러오지 못했어요."
                        )
                        print("애착 리포트 조회 오류:", failure)
                    }
                },
                receiveValue: { [weak self] dto in
                    self?.report = dto
                }
            )
            .store(in: &cancellables)
    }
}
