//
//  UseCaseService.swift
//  Symteo
//
//  Created by 박병선 on 2/3/26.
//
import Foundation

/// API 서비스 모델
class UseCaseService {

    let missionServise: MissionService
    let homeService: HomeService

    init() {
        self.missionServise = .init()
        self.homeService = .init()
    }
}

