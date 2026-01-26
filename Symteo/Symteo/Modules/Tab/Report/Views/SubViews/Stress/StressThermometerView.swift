//
//  StressThermometerView.swift
//  Symteo
//
//  Created by 박병선 on 1/25/26.
//

import SwiftUI

struct StressThermometerView: View {
    let ratio: CGFloat         // 0.0 ~ 1.0 (게이지가 차오르는 정도)
    let fillColor: Color       // 게이지 색상 (빨강, 노랑 등)
    
    let width: CGFloat = 300
    let height: CGFloat = 80

    var body: some View {
        ZStack(alignment: .leading) {
            //  배경: 빈 온도계 이미지
            Image("Thermometer_empty")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
            
            // 2. 게이지: 색상이 채워지는 부분
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // 실제 채워지는 색상 바
                    Rectangle()
                        .fill(fillColor)
                        // 온도계 머리(원형) 부분은 보통 전체의 15~20%를 차지하므로
                        // 최소 길이를 확보해주면 더 자연스럽습니다.
                        .frame(width: max(geometry.size.width * ratio, height * 0.8))
                }
            }
            .frame(width: width, height: height)
            // [핵심] 온도계 모양으로 색상을 깎아버림
            .mask(
                Image("Thermometer_empty")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: width, height: height)
            )
            
            // 3. (필요시) 눈금이나 외곽선 이미지를 위에 덧씌움
            // Image("Thermometer_outline")
            //     .resizable()
            //     .frame(width: width, height: height)
        }
        .frame(width: width, height: height)
    }
}

#Preview {
    StressThermometerView(
        ratio: 0.85,
        fillColor: Color(hex: "#F4574F") // 매우 위험
    )
    .padding()
    .background(Color.white)
}
