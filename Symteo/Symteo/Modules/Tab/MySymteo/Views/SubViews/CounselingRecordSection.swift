//
//  Untitled.swift
//  Symteo
//
//  Created by 박병선 on 2/6/26.
//
import SwiftUI

struct CounselingRecordSection: View {

    let isEmpty: Bool

    var body: some View {
        VStack{
            CounselingRecordInfoBanner()
            
            if isEmpty {
                CouselingEmptyView()
            } else {
                CounselingRecordListView()
            }
        }
    }
}

struct CounselingRecordInfoBanner: View {
    var body: some View {
        HStack {
            (
                Text("지금까지 진행한\n")
                    .font(.PretendardMedium(size: 16))
                +
                Text("상담 기록")
                    .font(.PretendardBold(size: 16))
                +
                Text("을 확인할 수 있어요")
                    .font(.PretendardMedium(size: 16))
            )
            .foregroundStyle(.green700)

            Spacer()

            Image("img-record")
                .resizable()
                .frame(width: 74, height: 65)
        }
        .padding()
        .background(.green30)
    }
}


struct CouselingEmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("lying_neulbo")
                .resizable()
                .frame(width: 90, height: 72)

            Text("상담 내역이 없어요")
                .font(.PretendardMedium(size: 14))
                .foregroundStyle(.gray500)

            Button {
                // TODO: 상담 화면 연결
            } label: {
                Text("상담 하러가기")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray900)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.maingreen)
                    )
            }
            Spacer()
        }
    }
}

