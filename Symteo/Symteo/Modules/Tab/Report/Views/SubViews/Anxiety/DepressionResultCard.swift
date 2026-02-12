//
//  AnxietyResultCard.swift
//  Symteo
//
//  Created by 박병선 on 1/20/26.
//
import SwiftUI

struct DepressionResultCard: View {

    let data: DepressionResult

    var body: some View {
        VStack(spacing: 16) {

            DepressionResultDetailView(
                totalScore: data.score,
                level: data.level
            )

            DepressionDescriptionSection(
                level: data.level,
                description: data.description
            )

            DepressionSymptomClusterSection(
                clusters: data.clusters
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

// MARK: - SubViews
///
private struct DepressionResultDetailView: View {
    let totalScore: Int
    let level: DepressionLevel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("우울증 척도 (PHQ-9)")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)
            
        /* -- 가운데 정렬-- */
            VStack(spacing: 0) {
                //  결과에 따라 이미지 변경
                Image(level.imageName)
                    .resizable()
                    .frame(width:290, height: 220)
                    .padding(.top)
                
                Text("총점: \(totalScore) 점")
                    .font(.PretendardMedium(size: 14))
                    .foregroundStyle(Color(hex: "000000"))
                    .padding(.top, -20)
                
                Text("(나의 우울 점수)")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(Color(hex: "000000"))
            }
                .frame(maxWidth: .infinity) // 부모는 왼쪽 정렬이지만, 이 VStack은 가로를 꽉 채워 중앙 정렬 효과
                .padding(.top) // 이미지와 텍스트 사이 간격
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 14, x: 0, y: 6)
    }
}

// MARK: -세부 설명
private struct DepressionDescriptionSection: View {

    let level: DepressionLevel
    let description: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10)  {

            HStack {
                Text("현재 우울 상태는")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)

                Text("'\(level.title)'")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(level.titleColor)

                Text("입니다.")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)
            }

            if let description {
                Text(description)
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray900)
                    //.multilineTextAlignment(.leading)  // ⭐️ 추가
                   // .frame(maxWidth: .infinity, alignment: .leading) // ⭐️ 추가
                    //.fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 14, x: 0, y: 6)
    }
}

// MARK: -주요 증상 클러스터
private struct DepressionSymptomClusterSection: View {
    
    let clusters: [PHQ9ClusterResult]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            // 타이틀
            Text("주요 증상 클러스터")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)

            ForEach(clusters, id: \.type) { cluster in
                DepressionSymptomClusterRowView(result: cluster)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.03), radius: 14, x: 0, y: 6)
    }
}

private struct DepressionSymptomClusterRowView: View {

    let result: PHQ9ClusterResult

    var body: some View {
        HStack(spacing: 12) {

            // 왼쪽 텍스트 영역
            VStack(alignment: .leading, spacing: 4) {
                Text(result.type.title)
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)

                Text(result.type.description)
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray700)
                    //.lineLimit(1)                 //  한 줄로 제한
                    //.minimumScaleFactor(0.8)
            }

            Spacer()

            // 오른쪽 Progress Bar
            ProgressBarView(ratio: result.ratio)
                .frame(width: 180) //  디자인 기준 최대 길이
        }
    }
}

private struct ProgressBarView: View {

    let ratio: Double

    private var level: AnxietyProgressSeverity {
        AnxietyProgressSeverity.from(ratio: ratio)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {

                // 배경 바
                Capsule()
                    .fill(Color.gray.opacity(0.15))

                // 채워지는 바
                Capsule()
                    .fill(level.progressColor)
                    .frame(width: geo.size.width * ratio)
            }
        }
        .frame(height: 10)
    }
}
