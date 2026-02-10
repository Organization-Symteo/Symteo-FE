//
//  ReportListRow.swift
//  Symteo
//
//  Created by 박병선 on 1/27/26.
//
import SwiftUI

/// 메인 리포트 화면에서 사용하는 리포트 한 줄(Row) 컴포넌트
/// 아이콘 + 제목/설명 + 오른쪽 화살표로 구성됨
/// 리포트가 존재할 경우 NavigationLink로 이동
/// 리포트가 없을 경우 팝업 등을 띄우는 액션 실행
struct ReportListRow<Destination: View>: View {

    /// 왼쪽에 표시할 아이콘 이미지 이름
    let icon: String

    /// 리포트 제목
    let title: String

    /// 리포트 부제목(설명)
    let subtitle: String

    /// 리포트 존재 여부
    /// true  → 리포트 화면으로 이동 가능
    /// false → 리포트 없음 팝업 표시
    let hasReport: Bool

    /// 리포트가 있을 때 이동할 목적지 View
    /// NavigationLink에서 호출되므로 클로저 형태로 전달
    let destination: () -> Destination

    /// 리포트가 없을 때 화살표를 눌렀을 경우 실행되는 액션
    /// 예: "저장된 리포트가 없습니다" 팝업 표시
    let onEmptyTap: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            // 왼쪽 아이콘
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)

            // 제목 + 부제목 영역
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.PretendardSemiBold(size: 18))
                    .foregroundStyle(.gray900)

                Text(subtitle)
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray700)
            }

            Spacer()

            // 오른쪽 화살표 영역
            // 리포트 존재 여부에 따라 동작 분기
            if hasReport {
                // 리포트가 있을 경우 NavigationLink로 이동
                NavigationLink(destination: destination) {
                    Image("chevron_right")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .buttonStyle(.plain) // 버튼 스타일 제거 (디자인 유지)
            } else {
                // 리포트가 없을 경우  팝업 등의 액션 실행
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
