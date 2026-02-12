//
//  MissionArrivedView.swift
//  Symteo
//
//  Created by 박병선 on 1/12/26.
//
import SwiftUI

struct MissionArrivedView: View {
    
    @ObservedObject var viewModel: MissionViewModel

    var body: some View {
        VStack(spacing: 40) {
            Text("오늘의 미션이 도착!\n지금 바로 열어보세요")
                .font(.PretendardMedium(size: 22))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray900)

            Button{
                viewModel.openMission()
            } label: {
                Image("mission_arrival")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
        }
    }
}
