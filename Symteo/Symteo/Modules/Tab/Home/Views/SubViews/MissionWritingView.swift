//
//  MissionWritingView.swift
//  Symteo
//
//  Created by 박병선 on 1/12/26.
//
import SwiftUI

struct MissionWritingView: View {
    let onSubmit: () -> Void //MARK: TODO -onSubmit 함수
    @State private var selectedImages: [UIImage] = []
    @State private var memo: String = ""
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = MissionViewModel()
    //let selectedWeather: EmotionWeather // 감정날씨
    
    @State private var showPicker: Bool = false      // ImagePicker 표시 여부
    @State private var tempImage: UIImage? = nil    // 선택된 이미지를 임시 저장
    // 팝업 상태 관리 변수들
    @State private var showSubmitConfirm: Bool = false // 완료 팝업 (하단)
    @State private var showExitConfirm: Bool = false   // 뒤로 가기 팝업 (중앙)
    
    var body: some View {
        ZStack { // ZStack은 기본적으로 모든 자식 뷰를 정중앙에 쌓습니다.
            VStack(spacing: 0) {
                navigationBar
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        missionHeader
                        photoSection
                        memoSection
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                }
                
                VStack {
                    MainBottomButton(
                        text: "완료",
                        isDisabled: selectedImages.isEmpty || memo.isEmpty,
                        action: { withAnimation { showSubmitConfirm = true } }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            }
            .disabled(showSubmitConfirm || showExitConfirm)
            
            // 배경 어둡게 처리
            if showSubmitConfirm || showExitConfirm {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showSubmitConfirm = false
                        showExitConfirm = false
                    }
            }
            
            // 2. 하단 팝업(완료 팝업) -> 팝업이 아니라 그냥 sheet로 수정해도 될 듯
            if showSubmitConfirm {
                VStack {
                    Spacer() // 이건 바닥에 붙어야 하니까 Spacer 유지
                    PopUpView(
                        title: "작성을 완료하셨나요?",
                        message: "[마이 심터 > 오늘 미션]에서 다시 볼 수 있어요.",
                        confirmTitle: "작성완료",
                        cancelTitle: "돌아가기",
                        onConfirm: {
                            showSubmitConfirm = false
                            onSubmit()
                        },
                        onCancel: { showSubmitConfirm = false }
                    )
                }
                .transition(.move(edge: .bottom))
            }
            
            // 3. [뒤로가기] 중앙 확인 팝업 (정중앙 배치)
            if showExitConfirm {
                // VStack과 Spacer를 삭제하면 ZStack에 의해 화면 정중앙에 뜹니다.
                PopUpView(
                    title: "미션을 그만두시겠습니까?",
                    message: "지금 나가시면 작성된 내용이 저장되지 않아요.",
                    confirmTitle: "계속하기",
                    cancelTitle: "그만두기",
                    onConfirm: {
                        showExitConfirm = false // 계속 작성하기
                    },
                    onCancel: {
                        showExitConfirm = false
                        dismiss() // 그만두고 나가기
                    }
                )
                .padding(.horizontal, 19) // 좌우 여백만 살짝 줌
                .transition(.opacity.combined(with: .scale)) // 중앙에서 나타나는 효과
            }
        }
    
        // MARK: - 시트 호출 위치를 ZStack 밖으로 이동
            .sheet(isPresented: $showPicker) {
                ImagePicker(image: $tempImage)
            }
            // onChange도 바깥으로 이동
            .onChange(of: tempImage) { newImage in
                if let newImage = newImage {
                    if selectedImages.count < 3 {
                        selectedImages.append(newImage)
                    }
                    tempImage = nil
                }
            }
    }

    // MARK: - Subviews
    
    // 네비게이션 바
    private var navigationBar: some View {
        ZStack {
            HStack {
                Button(action: { withAnimation { showExitConfirm = true } }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.black)
                }
                Spacer()
            }
            Text("오늘의 미션")
                .font(.PretendardRegular(size: 14))
                .foregroundStyle(.gray600)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }

    // 미션 헤더
    private var missionHeader: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 4) {
                Text(viewModel.timeRemainingString())
                    .font(.PretendardMedium(size: 12))
                    .foregroundStyle(.gray900)
                /*Image(selectedWeather.normalImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 22, height: 22)
                 */
            }
            .background(Color.white)
            .clipShape(Capsule())
            
            Text(viewModel.currentMission)
                .font(.PretendardRegular(size: 16))
                .foregroundStyle(.gray900)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color("gray5"))
        .cornerRadius(20)
    }

    // 사진 섹션
    private var photoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("사진")
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(.gray900)
                Spacer()
                Button(action: { /* MARK:  TODO 임시저장 버튼 구현 */ }) {
                    Text("임시저장")
                        .font(.PretendardRegular(size: 12))
                        .foregroundStyle(.gray400)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    photoAddButton
                    
                    ForEach(selectedImages.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing) {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(20)
                                .clipped()
                            
                            Button(action: { selectedImages.remove(at: index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .background(Color.gray900.opacity(0.5).clipShape(Circle()))
                            }
                            .offset(x: 4, y: -4)
                        }
                    }
                }
                .padding(.top, 5) // X버튼 공간 확보
            }
        }
    }

    // 메모 섹션
    private var memoSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("메모")
                .font(.PretendardSemiBold(size: 14))
                .foregroundStyle(.gray900)
            
            ZStack(alignment: .topLeading) {
                if memo.isEmpty {
                    Text("오늘 미션과 관련된 감정 일기를 적어보세요")
                        .font(.PretendardRegular(size: 14))
                        .foregroundStyle(.gray600)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 18)
                        .allowsHitTesting(false)
                }
                
                TextEditor(text: $memo)
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray900)
                    .frame(height: 150)
                    .padding(8)
                    .scrollContentBackground(.hidden)
                    .onChange(of: memo) { newValue in
                        if newValue.count > 300 {
                            memo = String(newValue.prefix(300))
                        }
                    }
            }
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray200, lineWidth: 1)
            )
            
            HStack {
                Spacer()
                Text("\(memo.count) / 300")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray600)
            }
        }
    }

    // 사진 추가 버튼 컴포넌트
    private var photoAddButton: some View {
        Button(action: {
            UIApplication.shared.hideKeyboard()
            showPicker = true
        }) {
            VStack(spacing: 12) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .light))
                    .foregroundStyle(.gray400)
                
                HStack(spacing: 0) {
                    Text("\(selectedImages.count)")
                        .foregroundStyle( Color(hex: "00A756"))
                    Text(" / 3장")
                        .foregroundStyle(.gray400)
                }
                .font(.PretendardMedium(size: 12))
            }
            .frame(width: 100, height: 100)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray200, lineWidth: 1.5)
            )
        }
        .disabled(selectedImages.count >= 3)
    }
}

#Preview {
    MissionWritingView(
            onSubmit: {}
        )
}
