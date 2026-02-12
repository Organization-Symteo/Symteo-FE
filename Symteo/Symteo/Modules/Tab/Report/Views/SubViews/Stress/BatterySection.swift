//
//  BatterySection.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
//  StressReportView 에서 마음 배터리를 보여주는 하위뷰입니다. 
import SwiftUI


struct BatterySection: View {
    let percent: Int   // percent만 받자

    private var status: BatteryStatus {
        BatteryStatus.from(percent: percent)
    }


    var body: some View {
        HStack(alignment: .center, spacing: 16) {

            // 왼쪽 배터리 아이콘
            Image(status.batteryImage)
                .resizable()
                .frame(width: 58, height: 50)

            //  오른쪽 텍스트 영역
            VStack(alignment: .leading, spacing: 6) {

                // 제목 + 퍼센트
                HStack(spacing: 4) {
                    Text("마음배터리:")
                        .font(.PretendardMedium(size: 16))
                        .foregroundStyle(.gray900)

                    Text("\(percent)%")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(status.titleColor)
                }

                // 설명 문구
                Text(status.guideText)
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray700)
                    .lineLimit(2)
            }

            Spacer()
        }
        .padding(16)
        .background(status.backgroundColor)
        .cornerRadius(16)
    }


}
