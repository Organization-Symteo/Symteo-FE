//
//  HomeView.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import SwiftUI
// 미션을 진행 상태별로 분기한 화면입니다.
struct MissionView: View {

    @StateObject private var viewModel = MissionViewModel(container: DIContainer())

    var body: some View {
        VStack {
            contentView
        }
        .navigationBarBackButtonHidden(true)
    }

    @ViewBuilder
    private var contentView: some View {
        switch viewModel.uiState {

        case .arrived:
            MissionArrivedView {
                viewModel.uiState = .confirmed
            }

        case .confirmed:
            MissionIntroView(
                onBack: {
                    viewModel.uiState = .arrived
                },
                onContinue: {
                    viewModel.uiState = .writing
                },
                viewModel: viewModel
            )

        case .writing:
            MissionWritingView(
                onSubmit: {
                    viewModel.completeMission()
                },
                viewModel: viewModel
            )

        case .completed:
            BaseTabView()
        }
    }
}

#Preview {
    MissionView()
}
