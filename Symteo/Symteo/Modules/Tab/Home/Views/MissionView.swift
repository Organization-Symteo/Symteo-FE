//
//  HomeView.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import SwiftUI
// 미션을 진행 상태별로 분기한 화면입니다.
struct MissionView: View {

    @EnvironmentObject var container: DIContainer
    @StateObject private var viewModel: MissionViewModel
    
    init(
        container: DIContainer
    ) {
        _viewModel = StateObject(wrappedValue: MissionViewModel(container: container))
    }

    
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
               MissionArrivedView(viewModel: viewModel)

           case .confirmed:
               MissionIntroView(viewModel: viewModel)

           case .writing:
               MissionWritingView(viewModel: viewModel)

           case .completed:
               EmptyView()
           }
       }
}

#Preview {
    MissionView(container: .init())
}
