//
//  OverallResultSection.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI


struct OverallResultSection: View {

    let result: OverallResult

    var body: some View {
        HStack(spacing: 12) {

            //  상태 아이콘
            Image(result.status.resultImage)
                .resizable()
                .frame(width: 48, height: 48)

            //  텍스트 영역
            VStack(alignment: .leading, spacing: 4) {

               
                // 종합결과 타이틀
            HStack(spacing: 4) {
                Text("종합결과:")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(Color(hex: "000000"))
                Text(result.status.title)
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(result.status.titleColor)
            }

                /// 영문 서브 타이틀
                Text("(\(result.status.subtitle))")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray700)
            }

            Spacer()
        }
        .padding(16)
        .background(result.status.backgroundColor)
        .cornerRadius(16)
    }
}

#Preview {
    OverallResultSection(
        result: OverallResult(
            phqScore: 9, gadScore: 9, averageScore: 9, status: .safe
        )
    )
    .padding()
    .background(Color.white)
}

