//
//  TestingViewModel.swift
//  Symteo
//
//  Created by 김지우 on 1/25/26.
//

import Foundation
import Combine
import Moya

struct SurveyQuestion: Identifiable, Hashable {
    let id: UUID
    let text: String
    let options: [String]
}

enum SurveyOptionPreset {
    static let depression: [String] = ["전혀 없었다", "며칠정도", "일주일 이상", "거의 매일"]
    static let stress: [String] = ["전혀 없었다", "거의 없었다", "가끔 있었다", "자주 있었다", "매우 자주 있었다"]
    static let agree: [String] = ["전혀 그렇지 않다", "그렇지 않다", "보통이다", "그렇다","매우 그렇다"]
}

enum SurveyQuestionBank {
    static let stressBurnout: [String] = [
        "최근 1개월 내, 예상치 못한 일이 생겨서 기분 나빠진 적이 얼마나 있었나요?",
        "최근 1개월 내, 중요한 일들을 통제할 수 없다고 느낀 적은 얼마나 있었나요?",
        "최근 1개월 내, 초조하거나 스트레스가 쌓인다고 느낀 적은 얼마나 있었나요?",
        "최근 1개월 내, 짜증나고 성가신 일들을 성공적으로 처리한 적이 얼마나 있었나요?",
        "최근 1개월 내, 생활 속에서 일어난 중요한 변화들을 효과적으로 대처한 적이 얼마나 있었나요?",
        "최근 1개월 내, 개인적인 문제를 처리하는 능력에 대해 자신감을 느낀 적은 얼마나 있었나요?",
        "최근 1개월 내, 자신의 뜻대로 일이 진행된다고 느낀 적은 얼마나 있었나요?",
        "최근 1개월 내, 매사를 잘 컨트롤하고 있다고 느낀 적이 얼마나 있었나요?",
        "최근 1개월 내, 당신이 통제할 수 없는 범위에서 발생한 일 때문에 화가 난 적이 얼마나 있었나요?",
        "최근 1개월 내, 어려운 일이 너무 많이 쌓여서 극복할 수 없다고 느낀 적은 얼마나 있었나요?",
        "최근 1개월 내, 일을 마친 후 심한 피로를 느낀다.",
        "최근 1개월 내, 업무 시작 전부터 지친 느낌이 든다.",
        "최근 1개월 내, 업무가 정신적으로 고갈된다는 생각이 자주 든다.",
        "최근 1개월 내, 일하다 보면 감정이 쉽게 소진되는 느낌이 든다.",
        "최근 1개월 내, 일이 너무 힘겹고 탈진하는 느낌이 자주 든다.",
        "최근 1개월 내, 아침에 일어나 출근을 생각하면 피곤함을 느낀다.",
        "최근 1개월 내, 업무 중 신경이 예민해지고 쉽게 짜증이 난다.",
        "최근 1개월 내, 업무를 마치고 나면 한동안 아무것도 하기 싫다.",
        "최근 1개월 내, 나 자신이 너무 감정적으로 소모된 느낌이 든다.",
        "최근 1개월 내, 고객이나 내담자에 대해 냉소적으로 말하게 된다.",
        "최근 1개월 내, 다른 사람을 인간적으로 대하기 어렵다고 느낀다.",
        "최근 1개월 내, 사람들에게 감정적으로 거리를 두고 있다.",
        "최근 1개월 내, 사람들을 기계적으로 대하는 내가 싫다.",
        "최근 1개월 내, 사람들의 문제에 무관심해진 나를 본다.",
        "최근 1개월 내, 상담이나 고객 대응이 점점 부담스럽게 느껴진다.",
        "최근 1개월 내, 자신의 일이 점점 의미 없게 느껴진다.",
        "최근 1개월 내, 업무 능력이 떨어진 것 같은 느낌이 든다.",
        "최근 1개월 내, 내가 하는 일이 사회적으로 큰 가치를 주지 못한다고 느낀다.",
        "최근 1개월 내, 현재 내가 맡은 역할에서 성취감을 느끼기 어렵다.",
        "최근 1개월 내, 일을 잘 해내고 있다는 확신이 줄어들고 있다.",
        "최근 1개월 내, 내 전문성에 대한 확신이 부족해지고 있다.",
        "최근 1개월 내, 업무에서 자부심을 잃어가고 있다고 느낀다."
    ]

    static let attachment: [String] = [
        "내가 얼마나 호감을 가지고 있는지 상대에게 보이고 싶지 않다.",
        "나는 버림받는 것에 대해 걱정하는 편이다.",
        "나는 다른 사람과 가까워지는 것이 매우 편안하다.",
        "나는 다른 사람과의 관계에 대해 많이 걱정하는 편이다.",
        "상대방이 나와 친해지려고 할 때 꺼려하는 나를 발견한다.",
        "내가 다른 사람에게 관심을 가지는 만큼 그들이 나에게 관심을 가지지 않을까봐 걱정한다.",
        "나는 다른 사람이 나와 매우 가까워지려 할 때 불편하다.",
        "나는 내가 다른 사람을 정말로 사랑할 수 있을지 걱정이 된다.",
        "나는 다른 사람에게 마음을 여는 것이 편안하지 못하다.",
        "나는 종종 내가 상대방에게 호의를 보이는 만큼 상대방도 그렇게 해주기를 바란다.",
        "나는 상대방과 가까워지기를 원하지만, 때로는 생각을 바꾸어 그만둔다.",
        "나는 상대방과 하나가 되길 원하기 때문에 사람들이 때때로 나에게서 멀어진다.",
        "나는 다른 사람이 나와 너무 가까워졌을 때 예민해진다.",
        "나는 혼자 남겨질까봐 걱정이다.",
        "나는 다른 사람에게 내 생각과 감정을 이야기하는 것이 편안하다.",
        "지나치게 친해지고자 하는 욕심 때문에 사람들이 두려워하여 거리를 둔다.",
        "나는 상대방과 너무 가까워지는 것을 피하려고 한다.",
        "나는 상대방으로부터 사랑받고 있다는 것을 자주 확인받고 싶어한다.",
        "나는 다른 사람과 가까워지는 것이 비교적 쉽다.",
        "가끔 나는 다른 사람에게 더 많은 애정과 헌신을 보이길 바란다.",
        "나는 다른 사람에게 의지하기가 어렵다.",
        "나는 버림받는 것에 대해 때로는 걱정하지 않는다.",
        "나는 다른 사람과 너무 가까워지는 것을 좋아하지 않는다.",
        "상대방이 나에게 관심을 잃지 않는다면 나는 행복하다.",
        "나는 상대방에게 모든 것을 이야기한다.",
        "상대방이 내가 원하는 만큼 가까워지지는 않을 것 같아 힘들다.",
        "나는 내가 다른 사람에게 내 문제와 고민을 상담하지 않는다.",
        "내가 필요로 할 때 상대방이 곁에 있지 않다면 실망한다.",
        "상대방이 나에게 불만을 나타낼 때 나 자신이 정말 형편없게 느껴진다.",
        "상대방이 나를 떠나서 많은 시간을 보내면 나는 불쾌하다.",
        "나는 상대방에게 의지하는 것이 불편하다.",
        "나는 버림받을까봐 걱정하지 않는다.",
        "나는 다른 사람과 가까워질수록 불안하다.",
        "나는 내가 상대방에게 너무 의존적인 것이 아닌지 걱정한다.",
        "나는 다른 사람에게 의지하지 않으려 노력한다.",
        "나는 상대방이 나를 떠날까봐 불안하다."
    ]

    static let depression: [String] = [
        "지난 2주일 동안, 일 또는 여가 활동을 하는 데 흥미나 즐거움을 느끼지 못함",
        "지난 2주일 동안, 기분이 가라앉거나, 우울하거나, 희망이 없음",
        "지난 2주일 동안, 잠이 들거나 계속 잠을 자는 것이 어려움, 또는 잠을 너무 많이 잠",
        "지난 2주일 동안, 피곤하다고 느끼거나 기운이 거의 없음",
        "지난 2주일 동안, 입맛이 없거나 과식을 함",
        "지난 2주일 동안, 자신을 부정적으로 봄 - 혹은 자신이 실패자라고 느끼거나 자신 또는 가족을 실망시킴",
        "지난 2주일 동안, 신문을 읽거나 텔레비전 보는 것과 같은 일에 집중하는 것이 어려움",
        "지난 2주일 동안, 다른 사람들이 주목할 정도로 너무 느리게 움직이거나 말을 함. 또는 반대로 평상시보다 많이 움직여서, 너무 안절부절못하거나 들떠 있음",
        "지난 2주일 동안, 자신이 죽는 것이 더 낫다고 생각하거나 어떤 식으로든 자신을 해칠 것이라고 생각함",
        "지난 2주일 동안, 초조하거나 불안하거나 조마조마하게 느낀다",
        "지난 2주일 동안, 걱정하는 것을 멈추거나 조절할 수가 없다",
        "지난 2주일 동안, 여러 가지 것들에 대해 걱걱정을 너무 많이 한다",
        "지난 2주일 동안, 편하게 있기가 어렵다",
        "지난 2주일 동안, 너무 안절부절못해서 가만히 있기가 힘들다",
        "지난 2주일 동안, 쉽게 짜증이 나거나 쉽게 성을 내게 된다",
        "지난 2주일 동안, 마치 끔찍한 일이 생길 것처럼 두렵게 느껴진다"
    ]
}

// MARK: - SurveyViewModel
final class SurveyViewModel: ObservableObject {

    @Published private(set) var questions: [SurveyQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var answers: [Int: Int] = [:]

    // 설문 제출 진행 상태
    @Published var isSubmitting: Bool = false

    // 제출 실패 시 사용자에게 표시할 에러 메시지
    @Published var submitErrorMessage: String? = nil

    // 생성된 진단 ID
    @Published var createdDiagnoseId: Int? = nil

    // 생성된 리포트 ID
    @Published var createdReportId: Int? = nil

    // 리포트 생성 실패 시 메시지
    @Published var reportErrorMessage: String? = nil

    // 리포트 생성 중 여부
    @Published var isCreatingReport: Bool = false

    let kind: SurveyKind
    private let service: TestService
    private var cancellables = Set<AnyCancellable>()

    // DIContainer를 통한 의존성 주입
    let container: DIContainer

    // MARK: - 초기화
    init(kind: SurveyKind, service: TestService, container: DIContainer) {
        self.kind = kind
        self.service = service
        self.questions = Self.makeQuestions(kind: kind)
        self.container = container
    }

    // 설문 종류에 따라 질문 구성
    static func makeQuestions(kind: SurveyKind) -> [SurveyQuestion] {
        let texts: [String]
        let options: [String]

        switch kind {
        case .stress:
            texts = SurveyQuestionBank.stressBurnout
            options = SurveyOptionPreset.stress
        case .attachment:
            texts = SurveyQuestionBank.attachment
            options = SurveyOptionPreset.agree
        case .depression:
            texts = SurveyQuestionBank.depression
            options = SurveyOptionPreset.depression
        }

        return texts.map {
            SurveyQuestion(id: UUID(), text: $0, options: options)
        }
    }

    // 진행률 계산
    var progress: CGFloat {
        guard !questions.isEmpty else { return 0 }
        return CGFloat(currentIndex + 1) / CGFloat(questions.count)
    }

    var currentQuestion: SurveyQuestion {
        questions[currentIndex]
    }

    func select(optionIndex: Int) {
        answers[currentIndex] = optionIndex
    }

    func isSelected(optionIndex: Int) -> Bool {
        answers[currentIndex] == optionIndex
    }

    func prev() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
    }

    func next() {
        guard currentIndex < questions.count - 1 else { return }
        currentIndex += 1
    }

    var isLast: Bool {
        currentIndex == max(0, questions.count - 1)
    }

    var hasUnanswered: Bool {
        answers.count < questions.count
    }

    func firstUnansweredIndex() -> Int? {
        let answered = Set(answers.keys)
        return (0..<questions.count).first { !answered.contains($0) }
    }

    func jumpToFirstUnanswered() {
        if let idx = firstUnansweredIndex() {
            currentIndex = idx
        }
    }

    // MARK: - 설문 제출 및 리포트 생성

    // 전체 처리 흐름
    // 1. 진단 생성 API 호출
    // 2. diagnoseId를 이용해 리포트 생성 API 호출
    // 3. reportId 저장
    //
    // 성공 시
    // - createdDiagnoseId 세팅
    // - createdReportId 세팅
    //
    // 실패 시
    // - submitErrorMessage 세팅
    //
    // 로딩 상태는 isSubmitting으로 관리

    @MainActor
    func submit() {

        submitErrorMessage = nil
        createdDiagnoseId = nil
        createdReportId = nil
        isSubmitting = true

        let request = CreateTestRequestDTO(
            testType: kind.testTypeString,
            answers: answers
                .sorted(by: { $0.key < $1.key })
                .map { CreateTestAnswerDTO(questionNo: $0.key + 1, score: $0.value) }
        )

        service.createTest(request)
            .flatMap { [weak self] res -> AnyPublisher<Int, APIError> in
                guard let self else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }

                self.createdDiagnoseId = res.diagnoseId

                switch self.kind {
                case .depression:
                    return self.container.useCaseService.reportService
                        .createDepressionAnxietyReport(diagnoseId: res.diagnoseId)
                        .map { $0.reportId }
                        .eraseToAnyPublisher()

                case .stress:
                    return self.container.useCaseService.reportService
                        .createStressReport(diagnoseId: res.diagnoseId)
                        .map { $0.reportId }
                        .eraseToAnyPublisher()

                case .attachment:
                    return self.container.useCaseService.reportService
                        .createAttachmentReport(diagnoseId: res.diagnoseId)
                        .map { $0.reportId }
                        .eraseToAnyPublisher()
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }

                self.isSubmitting = false

                if case let .failure(error) = completion {
                    self.submitErrorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] reportId in
                guard let self else { return }

                self.createdReportId = reportId

                let key = "reportId_\(self.kind.testTypeString)"
                UserDefaults.standard.set(reportId, forKey: key)
            })
            .store(in: &cancellables)
    }
}

// MARK: - SurveyKind Extension
private extension SurveyKind {
    var testTypeString: String {
        switch self {
        case .stress:
            return TestType.stressBurnoutComplex.rawValue
        case .attachment:
            return TestType.attachmentTest.rawValue
        case .depression:
            return TestType.depressionAnxietyComplex.rawValue
        }
    }
}
