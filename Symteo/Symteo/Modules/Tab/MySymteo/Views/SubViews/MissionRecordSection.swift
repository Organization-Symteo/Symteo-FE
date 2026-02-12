//
//  MissionRecordPage.swift
//  Symteo
//
//  Created by 박병선 on 2/6/26.
//
import SwiftUI

struct MissionRecordSection: View {

    let isEmpty: Bool

    var body: some View {
        VStack{
            MissionRecordInfoBanner()
            
            if isEmpty {// 미션 기록이 없을 때
                MissionEmptyView()
            } else {
                MissionRecordListView()
            }
        }
    }
}

struct MissionRecordInfoBanner: View {
    var body: some View {
        HStack {
            (
                Text("지금까지 진행한\n")
                    .font(.PretendardMedium(size: 16))
                +
                Text("미션 기록")
                    .font(.PretendardSemiBold(size: 16))
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

struct MissionEmptyView: View {
    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            Image("lying_neulbo")
                .resizable()
                .frame(width: 90, height: 72)

            Text("저장된 미션이 없어요")
                .font(.PretendardMedium(size: 14))
                .foregroundStyle(.gray500)

            NavigationLink {
               // MissionView(container: DIContainer)
            } label: {
                Text("미션 하러가기")
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


#Preview{
    MissionRecordSection(isEmpty: true)
}
