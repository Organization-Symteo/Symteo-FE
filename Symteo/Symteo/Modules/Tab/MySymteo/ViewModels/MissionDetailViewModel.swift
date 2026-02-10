//
//  MissionDetailViewModel.swift
//  Symteo
//
//  Created by 박병선 on 2/8/26.
//
import SwiftUI

/// 미션 상세 화면(MissionDetailView)의 상태와 로직을 담당하는 ViewModel
/// - 역할:
///   1) 미션 상세 조회
///   2) 조회 ↔ 수정 모드 전환
///   3) 메모 / 이미지 수정 상태 관리
///   4) 수정 내용 저장
@MainActor
final class MissionDetailViewModel: ObservableObject {
    
    //  프리뷰용 더미 데이터
        let mockMission = MissionDetail(
            id: 1,
            title: "오늘 하루 감사했던 일 3가지 적기",
            content: """
            오늘은 날씨가 정말 좋았다.
            하늘을 보며 잠깐 쉬는 시간이 있어서 감사했다.
            하루를 잘 마무리할 수 있어서 좋았다.
            """,
            imageURLs: [
                URL(string: "https://picsum.photos/200/200")!,
                URL(string: "https://picsum.photos/201/200")!
            ],
            completedAt: Date(),
            isCompleted: true
        )

        var isPreview: Bool = false 
    // MARK: - View State

    /// 서버에서 받아온 미션 상세 정보
    /// - 조회 모드에서 UI에 그대로 사용
    @Published var mission: MissionDetail?

    /// 로딩 인디케이터 제어용
    /// - API 호출 중 true
    @Published var isLoading: Bool = false

    /// 현재 수정 모드 여부
    /// - false: 조회 모드
    /// - true: 수정 모드
    @Published var isEditing: Bool = false

    // MARK: - Editing State (수정 중 임시 상태)

    /// 수정 중인 메모 내용
    /// - 조회 모드일 때는 mission.content를 사용
    /// - 수정 모드일 때만 사용되는 임시 값
    @Published var editedMemo: String = ""

    /// 수정 중 새로 추가한 이미지들
    /// - 서버 이미지(URL)와 분리된 로컬 상태
    @Published var selectedImages: [UIImage] = []
    

    // MARK: - Image Editing
    private let maxImageCount = 3
    
        /// 이미지 추가 (최대 개수 제한 포함)
        func addImage(_ image: UIImage) {
            guard selectedImages.count < maxImageCount else { return }
            selectedImages.append(image)
        }

        /// 특정 인덱스의 이미지 삭제
        func removeImage(at index: Int) {
            guard selectedImages.indices.contains(index) else { return }
            selectedImages.remove(at: index)
        }


    // MARK: - Fetch Mission Detail

    /// 미션 상세 조회 API 호출
    /// - Flow:
    ///   1) 로딩 시작
    ///   2) 서버에서 미션 상세 조회
    ///   3) mission / editedMemo 초기화
    ///   4) 로딩 종료
    func fetchMissionDetail(userMissionId: Int) async {
        isLoading = true
        defer { isLoading = false }

        // TODO: 실제 API 연결
        // let dto = try await api.fetchMissionDetail(id: userMissionId)

        // 임시 Mock 데이터
        let mock = MissionDetail(
            id: userMissionId,
            title: "오늘 하루 감사했던 일 3가지 적기",
            content: "오늘은 좋은 날이었다...",
            imageURLs: [],
            completedAt: Date(),
            isCompleted: true
        )

        // 조회 데이터 세팅
        mission = mock

        // 수정 모드 대비용 초기 메모 세팅
        editedMemo = mock.content
    }

    // MARK: - Editing Control

    /// 조회 모드 -> 수정 모드 전환
    /// - Text / Image 영역을 편집 가능 상태로 변경
    func startEditing() {
        isEditing = true
    }

    /// 수정 취소
    /// - 변경된 내용을 모두 버리고 조회 모드로 복귀
    /// - 메모는 원본 내용으로 되돌림
    /// - 추가된 이미지 초기화
    func cancelEditing() {
        isEditing = false
        editedMemo = mission?.content ?? ""
        selectedImages.removeAll()
    }

    // MARK: - Save Editing

    /// 수정 내용 저장
    /// - 서버에 수정 API 호출
    /// - 성공 시 조회 모드로 복귀
    func saveEditing() async {
        // TODO: 수정 API 호출
        /*
         PUT /missions/history/{userMissionId}
         body:
         - content: editedMemo
         - images: selectedImages
         */

        // 성공 가정
        isEditing = false
    }
}
