//
//  CounselingDetailView.swift
//  Symteo
//
//  Created by 박병선 on 2/7/26.
//
//  CounselingListView의 상세 화면입니다.
//
import SwiftUI

struct CounselingDetailView: View {

    /// 목록(리스트)에서 넘어온 최소 정보 (date/title/counselId 포함)
    let record: CounselingRecord

    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var container: DIContainer

    @StateObject private var viewModel = CounselingDetailViewModel()

    var body: some View {
        VStack(spacing: 0) {

            // MARK: - Header
            headerView

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    missionBanner

                    dateChip

                    // Loading / Error
                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.top, 8)
                    }

                    if let err = viewModel.errorMessage {
                        Text(err)
                            .font(.PretendardRegular(size: 12))
                            .foregroundStyle(.red)
                    }

                    let displayed = viewModel.record ?? record

                    summarySection(displayed)

                    userSection(displayed)

                    aiSection(displayed)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }

            bottomCTA
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            viewModel.load(
                chatRoomId: record.counselId,
                fallbackDate: record.date,
                fallbackTitle: record.title
            )
        }
    }
}

// MARK: - SubViews
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
        Button {
            // 미션 화면으로 이동
            container.navigationRouter.push(.mission)
        } label: {
            HStack {
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
        .buttonStyle(.plain)
    }

    var dateChip: some View {
        Text((viewModel.record?.date.isEmpty == false ? viewModel.record!.date : record.date))
            .font(.PretendardRegular(size: 13))
            .foregroundStyle(.gray600)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color.gray5)
            .cornerRadius(20)
    }

    func summarySection(_ record: CounselingRecord) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("상담 요약")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray700)

            Divider()

            HStack(spacing: 12) {
                Text("주제")
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(.gray900)

                Text(record.title)
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray900)
            }
        }
    }

    func userSection(_ record: CounselingRecord) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(icon: "mySymteo_pencil", title: "사용자")

            Text(record.userContent.isEmpty ? "요약이 없습니다." : record.userContent)
                .font(.PretendardRegular(size: 14))
                .foregroundStyle(.gray900)
        }
    }

    func aiSection(_ record: CounselingRecord) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader(icon: "mySymteo_message", title: "AI 답변")

            Text(record.aiResponse.isEmpty ? "요약이 없습니다." : record.aiResponse)
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
            // AI 상담 화면으로 이동
            container.selectedTab = .chat
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
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "#9EE3CF"),
                        Color(hex: "#E4F0CA")
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Preview
#Preview("Counseling Record Detail") {
    CounselingDetailView(
        record: CounselingRecord(
            counselId: 1,
            date: "2026년 2월 20일",
            title: "직장 스트레스와 번아웃 상담",
            userContent: "로딩 전 임시 텍스트",
            aiResponse: "로딩 전 임시 텍스트"
        )
    )
    .environmentObject(DIContainer())
}
