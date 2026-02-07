//
//  CounselingDetailView.swift
//  Symteo
//
//  Created by 박병선 on 2/7/26.
//
//  CounselingListView의 상세 화면입니다.
import SwiftUI

struct CounselingDetailView: View {

    let record: CounselingRecord
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            headerView

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    missionBanner

                    dateChip

                    summarySection

                    userSection

                    aiSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }

            bottomCTA
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

//MARK: -SubViews
private extension CounselingDetailView {
    
    var headerView: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("icn_arrow_left")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Spacer()
            }
            
            Text("상담기록")
                .font(.PretendardMedium(size: 16))
                .foregroundStyle(.gray900)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
    }
    
    var missionBanner: some View {
        HStack{
            
            VStack(alignment: .leading, spacing: 5) {
                Text("오늘만 참여할 수 있는 미션이 있어요👀")
                    .font(.PretendardRegular(size: 16))
                    .foregroundStyle(.green700)
                Text("오늘의 미션 하러가기")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.green800)
            }
            Spacer()

                Image("img-record")
                    .resizable()
                    .frame(width: 74, height: 65)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.green30)
            .padding(.horizontal, -20)
    }
    
    var dateChip: some View {
        Text(record.date)
            .font(.PretendardRegular(size: 13))
            .foregroundStyle(.gray600)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color.gray5)
            .cornerRadius(20)
    }
    
    var summarySection: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("상담 요약")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray700)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                infoRow(title: "주제", value: record.title)
                infoRow(title: "감정 상태", value: record.emotion)
            }
        }
    }
    
    func infoRow(title: String, value: String) -> some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.PretendardSemiBold(size: 14))
                .foregroundStyle(.gray900)
            
            Text(value)
                .font(.PretendardRegular(size: 14))
                .foregroundStyle(.gray900)
        }
    }
    
    var userSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(icon: "mySymteo_pencil", title: "사용자")
            
            Text(record.userContent)
                .font(.PretendardRegular(size: 14))
                .foregroundStyle(.gray900)
        }
    }
    var aiSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(icon: "mySymteo_message", title: "AI 답변")
            
            Text(record.aiResponse)
                .font(.PretendardRegular(size: 14))
                .foregroundStyle(.gray900)
        }
    }
    
    func sectionHeader(icon: String, title: String) -> some View {
        HStack(spacing: 8) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(.PretendardSemiBold(size: 15))
                .foregroundStyle(.gray900)
        }
    }
    
    var bottomCTA: some View {
        Button(action: {
            // TODO: 액션 추가
        }) {
            HStack {
                Image("message_notify_circle")
                    .resizable()
                    .frame(width: 32, height: 32)
                VStack(alignment: .leading) {
                    Text("다른 내용으로 상담하고 싶어요")
                        .font(.PretendardRegular(size: 14))
                        .foregroundStyle(.green600)
                    Text("AI 상담 바로가기 ")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(.green600)
                }
               
                Spacer()
            }
            .frame(width: 300, height: 25)
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "#9EE3CF"),
                        Color(hex: "#E4F0CA")],
                    startPoint: .leading,
                    endPoint: .trailing))
            .cornerRadius(16)
        }
    }
}

#Preview("Counseling Record Detail") {
    CounselingDetailView(
        record: CounselingRecord(
            date: "2025년 11월 04일",
            title: "직장 스트레스와 번아웃 상담",
            emotion: "지침",
            userContent: """
팀장님과의 갈등으로 퇴사까지 고민하고 있습니다.
무기력감이 심하고 가슴이 답답한 느낌이 자주 듭니다.
병원에 가야 할지 고민 중입니다.
""",
            aiResponse: """
현재 느끼는 감정은 충분히 이해할 수 있어요.
지금은 자신을 탓하기보다 작은 휴식부터 시작해보세요.
증상이 지속된다면 전문적인 상담이나 병원 진료도 추천드립니다.
"""
        )
    )
}
