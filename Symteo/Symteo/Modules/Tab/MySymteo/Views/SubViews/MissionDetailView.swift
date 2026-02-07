//
//  MissionDetailView.swift
//  Symteo
//
//  Created by 박병선 on 2/7/26.
//
//  오늘의 미션 리스트 클릭 시 -> 이동하는 화면입니다.
import SwiftUI

struct MissionDetailView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var showPicker: Bool = false
    @State private var tempImage: UIImage? = nil
    @State private var showExitConfirm: Bool = false
    
    let userMissionId: Int
    @StateObject private var viewModel = MissionDetailViewModel()


    

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                navigationBar

                ScrollView {
                    if let mission = viewModel.mission {
                        VStack(alignment: .leading, spacing: 24) {
                            missionHeader(mission)
                            photoSection(mission)
                            memoSection(mission)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                    }
                }
                if let mission = viewModel.mission {

                    // 수정 모드 → 저장 버튼
                    if viewModel.isEditing {
                        MainBottomButton(
                            text: "저장",
                            isDisabled: viewModel.editedMemo.isEmpty,
                            action: {
                                Task {
                                    await viewModel.saveEditing()
                                }
                            }
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)

                    //  조회 모드 + 이미 완료된 미션 → 완료 버튼
                    } else if mission.isCompleted {
                        MainBottomButton(
                            text: "완료",
                            isDisabled: true,   // 항상 비활성화
                            action: {}
                        )
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                }
            }
            .disabled(showExitConfirm)

            if showExitConfirm {
                Color.black.opacity(0.4).ignoresSafeArea()
                PopUpView(
                    title: "수정을 취소하시겠어요?",
                    message: "지금 나가면 변경된 내용이 저장되지 않아요.",
                    confirmTitle: "계속 수정하기",
                    cancelTitle: "나가기",
                    onConfirm: { showExitConfirm = false },
                    onCancel: {
                        showExitConfirm = false
                        dismiss()
                    }
                )
                .padding(.horizontal, 19)
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .sheet(isPresented: $showPicker) {
            ImagePicker(image: $tempImage)
        }
        .onChange(of: tempImage) { newImage in
            guard let newImage else { return }
            viewModel.addImage(newImage)
            tempImage = nil
        }
        .onAppear {
            //  프리뷰일 경우
            if viewModel.isPreview {
                viewModel.mission = viewModel.mockMission
                viewModel.editedMemo = viewModel.mockMission.content
                return
            }

            // 실제 앱 실행 시
            Task {
                await viewModel.fetchMissionDetail(userMissionId: userMissionId)
            }
        }
    }
}
private extension MissionDetailView {

    var navigationBar: some View {
        ZStack {
            HStack {
                Button {
                    if viewModel.isEditing {
                        showExitConfirm = true
                    } else {
                        dismiss()
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16))
                        .foregroundStyle(.black)
                }
                Spacer()
            }

            Text("오늘의 미션")
                .font(.PretendardRegular(size: 14))
                .foregroundColor(.gray600)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    func missionHeader(_ mission: MissionDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {

            /// 상단 캡슐
            HStack(spacing: 8) {
                Text("#\(String(format: "%02d", mission.id))")
                    .font(.PretendardMedium(size: 12))
                    .foregroundColor(.gray700)

                Text(mission.completedAt.formattedDate)
                    .font(.PretendardMedium(size: 12))
                    .foregroundColor(.gray700)

            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white.opacity(0.6))
            .clipShape(Capsule())
            .frame(maxWidth: .infinity, alignment: .leading)

            /// 미션 질문 (title)
            Text(mission.title)
                .font(.PretendardRegular(size: 16))
                .foregroundColor(.gray900)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("gray5"))
        .cornerRadius(20)
    }

    func photoSection(_ mission: MissionDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("사진")
                    .font(.PretendardSemiBold(size: 14))
                Spacer()
                if viewModel.isEditing {
                    Button("추가") {
                        showPicker = true
                    }
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray400)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    if viewModel.isEditing {
                        ForEach(viewModel.selectedImages.indices, id: \.self) { index in
                            Image(uiImage: viewModel.selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .clipped()
                        }
                    } else {
                        ForEach(mission.imageURLs, id: \.self) { url in
                            AsyncImage(url: url) { image in
                                image.resizable().scaledToFill()
                            } placeholder: {
                                Color.gray200
                            }
                            .frame(width: 100, height: 100)
                            .cornerRadius(20)
                            .clipped()
                        }
                    }
                }
            }
        }
    }

    func memoSection(_ mission: MissionDetail) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메모")
                .font(.PretendardSemiBold(size: 14))

            if viewModel.isEditing {
                TextEditor(text: $viewModel.editedMemo)
                    .font(.PretendardRegular(size: 14))
                    .frame(height: 150)
                    .padding(8)
                    .background(Color.white)
                    .cornerRadius(12)
            } else {
                Text(mission.content)
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray900)
                    .padding(16)
                    .background(Color.white)
                    .cornerRadius(12)
                    .onTapGesture {
                        viewModel.startEditing()
                    }
            }
        }
    }
}


#Preview {
    NavigationStack {
        MissionDetailView(userMissionId: 1)
            .onAppear {
                // 프리뷰용 세팅
                let mirror = Mirror(reflecting: MissionDetailView(userMissionId: 1))
            }
    }
}
