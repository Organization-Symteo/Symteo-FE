//
//  DepressionResultCard.swift
//  Symteo
//
//  Created by 박병선 on 1/20/26.
//
import SwiftUI

struct AnxietyResultCard: View {

    let data: AnxietyResult

    var body: some View {
        VStack(spacing: 16) {

            AnxietyResultDetailView(
                totalScore: data.score,
                level: data.level
            )

            AnxietyDescriptionSection(
                level: data.level,
                description: data.description
            )

            AnxietySymptomClusterSection(
                clusters: data.clusters
            )
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

// MARK: - SubViews
///
private struct AnxietyResultDetailView: View {

    let totalScore: Int
    let level: AnxietyLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            Text("불안 척도 (GAD-7)")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)

            VStack(spacing: 0) {
                Image(level.imageName)
                    .resizable()
                    .frame(width: 280, height: 210)
                    .padding(.top)

                Text("총점: \(totalScore) 점")
                    .font(.PretendardMedium(size: 14))
                    .padding(.top, -20)

                Text("(나의 불안 점수)")
                    .font(.PretendardRegular(size: 14))
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 14, x: 0, y: 6)
    }
}

// MARK: -세부 설명
private struct AnxietyDescriptionSection: View {

    let level: AnxietyLevel
    let description: String?

    var body: some View {
        VStack(spacing: 10) {

            HStack {
                Text("현재 불안 상태는")
                Text("'\(level.title)'")
                    .foregroundStyle(level.titleColor)
                Text("입니다.")
            }
            .font(.PretendardSemiBold(size: 16))
            .foregroundStyle(.gray900)

            if let description {
                Text(description)
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray900)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 14, x: 0, y: 6)
    }
}
// MARK: -주요 증상 클러스터
private struct AnxietySymptomClusterSection: View {

    let clusters: [GAD7ClusterResult]

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("주요 증상 클러스터")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)

            ForEach(clusters, id: \.type) { cluster in
                AnxietyClusterRowView(result: cluster)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.03), radius: 14, x: 0, y: 6)
    }
}

private struct AnxietyClusterRowView: View {

    let result: GAD7ClusterResult

    var body: some View {
        HStack(spacing: 12) {

            VStack(alignment: .leading, spacing: 4) {
                Text(result.type.title)
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)

                Text(result.type.description)
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray700)
                   // .lineLimit(1)
            }

            Spacer()

            ProgressBarView(ratio: result.ratio)
                .frame(width: 180)
        }
    }
}

private struct ProgressBarView: View {

    let ratio: Double

    private var level: ProgressSeverity {
        ProgressSeverity.from(ratio: ratio)
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

// 프리뷰용 더미 데이터

#Preview {
    AnxietyResultCard(
        data: .preview
    )
}
