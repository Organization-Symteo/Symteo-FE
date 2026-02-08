//
//  MissionArrivedView.swift
//  Symteo
//
//  Created by 박병선 on 1/12/26.
//
import SwiftUI

struct MissionArrivedView: View {
    
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 40) {
            Text("오늘의 미션이 도착!\n지금 바로 열어보세요")
                .font(.PretendardMedium(size: 22))
                .multilineTextAlignment(.center)
                .foregroundColor(.gray900)

            Button(action: onStart) { /// 화면전환만 담당
                Image("mission_arrival") // 에셋 확인 필요
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
            }
        }
    }
}
