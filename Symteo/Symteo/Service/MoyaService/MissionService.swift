//
//  MissionService.swift
//  Symteo
//
//  Created by 박병선 on 2/1/26.
//

import Foundation
import Combine
import Moya
import CombineMoya

/// 미션 서비스 프로토콜
protocol MissionServiceProtocol {
    
    /// 오늘의 미션 요청
    func fetchTodayMission() -> AnyPublisher<TodayMissionResult, APIError>
    
    /// 미션 시작
    func startMission(missionId: Int,data: MissionStartRequest) -> AnyPublisher<MissionStartResult, APIError>
    
    /// 미션 텍스트 제출
    func saveMissionDraft(userMissionId: Int,data: MissionDraftRequest) -> AnyPublisher<MissionDraftResult, APIError>
    
    /// 미션 제출
    func completeMission(userMissionId: Int) -> AnyPublisher<StatusResponseOnly, APIError>
    
    /// 미션 새로고침
    func restartTodayMission() -> AnyPublisher<MissionRestartResponse, APIError>
    
}


/// 미션 API 를 사용하는 서비스
final class MissionService: MissionServiceProtocol {

    /// MoyaProvider를 통해 API 요청 전송
    let provider: MoyaProvider<MissionRouter>

    init(provider: MoyaProvider<MissionRouter> = APIManager.shared.createProvider(for: MissionRouter.self)) {
        self.provider = provider
    }

    // MARK: - 오늘 미션 조회
    func fetchTodayMission() -> AnyPublisher<TodayMissionResult, APIError> {
        provider.requestResult(MissionRouter.fetchTodayMission,type: TodayMissionResult.self)
    }
    
    // MARK: - 미션 시작
    func startMission(missionId: Int,data: MissionStartRequest) -> AnyPublisher<MissionStartResult, APIError> {
        provider.requestResult(MissionRouter.startMission(missionId: missionId, data: data),type: MissionStartResult.self)
    }
    
    // MARK: - 미션 텍스트 임시 저장
    func saveMissionDraft(userMissionId: Int,data: MissionDraftRequest) -> AnyPublisher<MissionDraftResult, APIError> {
        provider.requestResult(MissionRouter.saveMissionDraft(userMissionId: userMissionId,data: data),type: MissionDraftResult.self)
    }
    
    // MARK: - 미션 제출
    func completeMission(userMissionId: Int) -> AnyPublisher<StatusResponseOnly, APIError> {
            provider.requestStatus(MissionRouter.completeMission(userMissionId: userMissionId))
        }
    
    // MARK: - 미션 새로고침
    func restartTodayMission() -> AnyPublisher<MissionRestartResponse, APIError> {
        provider.requestResult(MissionRouter.restartTodayMission, type: MissionRestartResponse.self)
    }
}
