//
//  Untitled.swift
//  Symteo
//
//  Created by 박병선 on 1/12/26.
//
import SwiftUI

struct MissionIntroView: View {
    @ObservedObject var viewModel: MissionViewModel

    var body: some View {
        VStack(spacing: 0) {

            // 1. 커스텀 네비게이션 바
            ZStack {
                HStack {
                    Button{
                        viewModel.goBackToArrived()
                    } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.black)
                    }
                    Spacer()
                }

                Text("오늘의 미션")
                    .font(.PretendardRegular(size: 14))
                    .foregroundColor(.gray600)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Spacer()

            // 2. 남은 시간 표시
            VStack(spacing: 8) {
                Text("남은 시간")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray600)

                Text(viewModel.timeRemainingString())
                    .font(.PretendardMedium(size: 22))
                    .foregroundStyle(.gray900)
            }
            .padding(.bottom, 40)

            // 3. 중앙 미션 카드 영역
            ZStack {
                Image("mission_bg_envelope")
                    .resizable()
                    .frame(width: 390, height: 300)
                    .offset(x: 80, y: 40)

                VStack(spacing: 0) {
                    Spacer()

                    Text(viewModel.missionContent)
                        .font(.OwnGlyphPDH(size: 16))
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)
                        .foregroundColor(.gray700)
                        .padding(.horizontal, 20)

                    Spacer()
                    VStack (spacing: 0) {
                        // 새로고침 (서버 재요청)
                        Button {
                            viewModel.restartTodayMission()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 30)
                        
                        Text("(\(viewModel.refreshCount)회)")
                            .font(.OwnGlyphPDH(size: 12))
                            .foregroundColor(.gray700)
                            .padding(.bottom)
                    }
                }
                .frame(width: 225, height: 272)
                .background(Color.white)
                .cornerRadius(24)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color(hex: "707070"), lineWidth: 4)
                )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)

            Spacer()

            // 4. 하단 미션 시작 버튼
            MainBottomButton(
                text: "미션 시작",
                isDisabled: false,
                action: {
                    viewModel.startMission()/// API startMission함수 호출(missionId가 필요함)
                }
            )
            .padding()
        }
        .background(Color.white.ignoresSafeArea())
    }
}


