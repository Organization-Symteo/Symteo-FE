//
//  HomeView.swift
//  Symteo
//
//  Created by 박병선 on 1/7/26.
//
import SwiftUI


// 미션의 진행상태별로 분기하는 뷰입니다

struct MissionView: View {

    @State private var missionState: MissionState = .arrived
    @State private var showSubmitConfirm = false   // confirming 대체
    
    
    var body: some View {
        VStack {
            contentView
        }
        .navigationBarBackButtonHidden(true) // 기본 BackButton 숨김
    }

    @ViewBuilder
    private var contentView: some View {
        switch missionState {
        
        case .arrived: // 미션 도착 화면
            MissionArrivedView {
                missionState = .confirmed
            }

        case .confirmed:
            MissionIntroView(
                onBack: {
                    missionState = .arrived
                },
                onContinue: {
                    missionState = .writing
                }
            )

        case .writing: // 미션 작성 화면
            MissionWritingView(
                onSubmit:  {
                    missionState = .completed
                }
            )

        case .completed:
            BaseTabView()
        }
    }
}

#Preview {
    MissionView()
}
