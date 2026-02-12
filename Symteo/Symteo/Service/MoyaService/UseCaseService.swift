//
//  UseCaseService.swift
//  Symteo
//

//
import Foundation

/// API 서비스 모델
class UseCaseService {


    let missionServise: MissionService
    let homeService: HomeService
    let reportService: ReportService


    init() {

       self.missionServise = .init()
       self.homeService = .init()
        self.reportService = .init()
    }

}
