//
//  MissionRecordListView.swift
//  Symteo
//
//  Created by 박병선 on 2/6/26.
//
import SwiftUI

struct MissionRecordListView: View {

    // 임시 더미 데이터 ( API 응답으로 교체)
    private let missions: [MissionList] = [
        MissionList(
            id: 1,
            title: "내가 좋은 이유 3가지 적기",
            completedAt: Date(),
            hasImage: true
        ),
        MissionList(
            id: 2,
            title: "오늘 하루 감사한 일 적기",
            completedAt: Date().addingTimeInterval(-86400),
            hasImage: false
        )
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(missions) { mission in
                        MissionRecordCell(record: mission)
                    }
                }
                .padding()
            }
        }
    }
}

struct MissionRecordCell: View {

    let record: MissionList

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {

                // #01 형태
                Text("#\(String(format: "%02d", record.id))")
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(.maingreen)

    
                    Text(record.completedAt.formattedDate)
                        .font(.PretendardRegular(size: 12))
                        .foregroundStyle(.gray600)


                Text(record.title)
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(.gray900)
            }

            Spacer()

            NavigationLink {
                MissionDetailView(userMissionId: record.id)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray700)
            }
            .buttonStyle(.plain)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 12, x: 0, y: 6)
    }
}

#Preview("Mission Record List") {
    MissionRecordListView()
}
