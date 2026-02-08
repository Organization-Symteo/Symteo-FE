//
//  MySymteoView.swift
//  Symteo
//
//  Created by 박정환 on 1/19/26.
//

import SwiftUI

struct MySymteoView: View {

    @EnvironmentObject private var container: DIContainer

    private enum Layout {
        static let horizontalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 16

        static let cardCornerRadius: CGFloat = 12
        static let cardInnerPadding: CGFloat = 16

        static let avatarSize: CGFloat = 64
    }

    private let userName: String = "홍따오기"

    var body: some View {

        NavigationStack(path: $container.navigationRouter.path) {

            VStack(alignment: .leading, spacing: Layout.sectionSpacing) {

                header
                profileRow
                missionHistoryCard
                monthlyTrendCard

                Spacer(minLength: 24)
            }
            .padding(.horizontal, Layout.horizontalPadding)
            .background(Color(.gray5).ignoresSafeArea())

            .navigationDestination(for: NavigationDestination.self) { destination in

                switch destination {

                case .setting:
                    SettingView()

                case .privacy:
                    PrivacyPolicyView()

                case .service:
                    ServicePolicyView()
                    

                }
            }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Text("MY 심터")
                .font(.PretendardSemiBold(size: 18))
                .foregroundColor(.gray900)

            Spacer()

            Button {
                container.navigationRouter.push(.setting)
            } label: {
                Image("icn_setting")
            }
        }
        .padding(.top, 24)
    }

    // MARK: - Profile

    private var profileRow: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.gray30)

                Image("img-person")
            }
            .frame(width: Layout.avatarSize, height: Layout.avatarSize)

            VStack(alignment: .leading, spacing: 6) {
                Text("안녕하신가요?")
                    .font(.PretendardRegular(size: 14))
                    .foregroundColor(.gray700)

                Text("\(userName) 님")
                    .font(.PretendardSemiBold(size: 18))
                    .foregroundColor(.gray900)
            }

            Spacer()
        }
        .padding(.top, 8)
    }

    // MARK: - Cards

    private var missionHistoryCard: some View {
        VStack(spacing: 0) {
            Image("img-missionTop")
                .resizable()
                .scaledToFit()

            NavigationLink {
                MySymteoRecordView()
            } label: {
                HStack(spacing: 12) {
                    Image("img-mission")
                        .foregroundColor(.gray700)
                        .frame(width: 40, height: 40)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("미션·상담기록")
                            .font(.PretendardMedium(size: 16))
                            .foregroundColor(.gray900)

                        Text("한 눈에 다시 보기")
                            .font(.PretendardMedium(size: 12))
                            .foregroundColor(.gray600)
                    }

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray500)
                }
                .padding(.horizontal, Layout.cardInnerPadding)
                .padding(.vertical, 18)
                .frame(maxWidth: .infinity)
                .background(Color.white)
            }
            .buttonStyle(.plain)
        }
        .clipShape(
            RoundedCorner(
                radius: Layout.cardCornerRadius,
                corners: [.bottomLeft, .bottomRight]
            )
        )
        .shadow(color: Color.black.opacity(0.03), radius: 14, x: 0, y: 6)
    }

    private var monthlyTrendCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("월간 상태변화 추이")
                .font(.PretendardSemiBold(size: 16))
                .foregroundColor(.gray900)

            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(Color.gray200, lineWidth: 1)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

                VStack(spacing: 8) {
                    Image("img-lock")
                        .font(.system(size: 16))
                        .foregroundColor(.gray500)

                    Text("업데이트 예정")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundColor(.gray900)
                }
            }
            .frame(height: 307)
        }
        .padding(Layout.cardInnerPadding)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Layout.cardCornerRadius, style: .continuous))
        .shadow(color: Color.black.opacity(0.03), radius: 12, x: 0, y: 6)
    }
}



#Preview {
    MySymteoView()
}
