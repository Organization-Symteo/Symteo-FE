//
//  ReportNavigationBar.swift
//  Symteo
//
//  Created by 박병선 on 1/19/26.
//
import SwiftUI

struct ReportNavigationBar: View {
    let userName: String
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var container: DIContainer
    @EnvironmentObject var sessionmanager: SessionManager


    var body: some View {
        HStack(spacing: 10) {

            Button {
                container.navigationRouter.moveToMainReport()
            } label: {
                Image("arrow_left")
                    .resizable()
                    .frame(width: 25, height: 25)
            }

            Image("report_profile")
                .resizable()
                .frame(width: 30, height: 30)

            VStack(alignment: .leading, spacing: 2) {
                Text("오늘도 마음을 돌보는")
                    .font(.PretendardSemiBold(size: 16))
                Text("당신을 응원합니다. \(sessionmanager.userName)님")
                    .font(.PretendardSemiBold(size: 16))
            }
            .foregroundStyle(.white)
            .padding(.leading, 5)

            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 16)
        .background(
            Color.maingreen
                .clipShape(
                    RoundedCorner(
                        radius: 24,
                        corners: [.bottomLeft, .bottomRight]
                    )
                )
        )
    }
}

