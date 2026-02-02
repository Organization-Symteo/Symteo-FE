//
//  OnboardingView.swift
//  Symteo
//
//  Created by 박정환 on 1/27/26.
//

import SwiftUI

struct OnboardingView: View {

    @State private var currentPage = 0

    private let images = [
        "img_onboarding_1",
        "img_onboarding_2",
        "img_onboarding_3",
        "img_onboarding_4"
    ]

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                TabView(selection: $currentPage) {
                    ForEach(images.indices, id: \.self) { index in
                        Image(images[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .frame(maxHeight: .infinity)
            .padding(.top, 200)

            HStack(spacing: 6) {
                ForEach(images.indices, id: \.self) { index in
                    Capsule()
                        .fill(
                            currentPage == index
                            ? Color.maingreen
                            : Color.gray100
                        )
                        .frame(
                            width: currentPage == index ? 18 : 8,
                            height: 8
                        )
                }
            }
            .padding(.bottom, 32)

            MainBottomButton(
                text: "다음",
                isDisabled: false,
                action: {
                    nextPage()
                }
            )
            .padding(.bottom, 16)
        }
        .background(
            Image("img_onboarding_bg")
                .resizable()
                .scaledToFit()
        )
    }

    private func nextPage() {
        if currentPage < images.count - 1 {
            withAnimation {
                currentPage += 1
            }
        } else {
            // 페이지 이동
            print("온보딩 종료")
        }
    }
}

#Preview {
    OnboardingView()
}
