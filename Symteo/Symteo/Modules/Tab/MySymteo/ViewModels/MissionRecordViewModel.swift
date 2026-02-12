//
//  MissionRecordViewModel.swift
//  Symteo
//
//  Created by 박병선 on 2/7/26.
//
import SwiftUI
import Foundation
import Combine


@MainActor
final class MissionRecordListViewModel: ObservableObject {
    @Published var missions: [MissionList] = []

    /*
    func fetchMissions() async {
        let response = try await api.fetchMissionHistory()
        self.missions = response.result.missions.map { $0.toDomain() }
    }
     */
}
