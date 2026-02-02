//
//  ReportListRow.swift
//  Symteo
//
//  Created by 박병선 on 1/27/26.
//
import SwiftUI

struct ReportListRow: View {

    let icon: String
    let title: String
    let subtitle: String
    let hasReport: Bool
    let destination: AnyView
    let onEmptyTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {

        
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
        

            // 텍스트
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.PretendardSemiBold(size: 18))
                    .foregroundStyle(.gray900)

                Text(subtitle)
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray700)
            }

            Spacer()

            //  화살표만 인터랙션
            if hasReport {
                NavigationLink(destination: destination) {
                    Image("chevron_right")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain)
            } else {
                Button(action: onEmptyTap) {
                    Image("chevron_right")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
            }
        }
        .padding()
    }
}
