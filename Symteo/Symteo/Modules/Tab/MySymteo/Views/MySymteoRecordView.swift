//
//  RecordViw.swift
//  Symteo
//
//  Created by 박병선 on 2/6/26.
//  마이심터에서 상담 기록과 미션 기록을 확인하는 View입니다.
import SwiftUI

struct MySymteoRecordView: View {

    @State private var selectedTab: Int = 0
    @Environment(\.dismiss) private var dismiss // 뒤로가기 버튼
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        VStack(spacing: 0) {

            // 상단 탭
            RecordTabHeader(selectedTab: $selectedTab, onBack: { dismiss() })


            // 스와이프 영역
            TabView(selection: $selectedTab) {
                MissionRecordSection(isEmpty: false)
                    .tag(0)

                CounselingRecordSection(isEmpty: false)
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .toolbar(.hidden, for: .navigationBar) // 기본 네비게이션바 숨김
    }
}

// MARK: -SubViews
struct RecordTabHeader: View {

    @Binding var selectedTab: Int
    let onBack: () -> Void

    private let sideWidth: CGFloat = 120  // 좌우 폭 동일

    var body: some View {
        HStack(spacing: 0) {

            ///뒤로가기 (고정 폭)
            Button(action: onBack) {
                Image("icn_arrow_left")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .frame(width: sideWidth, height: 56) // 터치 영역 포함
            }
            .offset(x: -30)
            
            

            /// 탭 묶음
            HStack(spacing: 5) {
                tabButton(title: "미션 기록", index: 0)
                tabButton(title: "상담 기록", index: 1)
            }
            .frame(maxWidth: .infinity)

            /// 빈 슬롯
            Color.clear
                .frame(width: sideWidth, height: 56)
        }
        .frame(height: 56)
    }

    private func tabButton(title: String, index: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = index
            }
        } label: {
            VStack(spacing: 6) {
                Text(title)
                    .font(.PretendardMedium(size: 14))
                    .foregroundStyle(selectedTab == index ? .gray900 : .gray500)

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(selectedTab == index ? .gray900 : .clear)
            }
        }
    }
}




#Preview {
    MySymteoRecordView()
}
