//
//  AttachmentResultCard.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI


struct AttachmentResultCard: View {
    @ObservedObject var viewModel: AttachmentReportViewModel

    var body: some View {
        VStack(spacing: 16) {

            if let anxiety = viewModel.anxietyResult,
                           let avoidance = viewModel.avoidanceResult {

                            AttachmentMapSection(
                                anxietyResult: anxiety,
                                avoidanceResult: avoidance
                            )
                            .reportCardStyle()

                        } else {
                            // 로딩 or placeholder
                            ProgressView()
                        }


            if let type = viewModel.attachmentType {
                AttachmentDescriptionSection(
                    userName: viewModel.userName,
                    attachmentType: type,
                    description: viewModel.description
                )
                .reportCardStyle()
            }
                
        }
        
    }
}
        
//MARK: -SubViews(private)
private struct AttachmentMapSection: View {

    let anxietyResult: AttachmentBarResult
    let avoidanceResult: AttachmentBarResult

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text("나의 관계 지도 (ECR-R 4분면)")
                .font(.PretendardSemiBold(size: 16))
                .foregroundStyle(.gray900)
                .padding(.leading)

            Image("relation_map")
                .resizable()
                .frame(width: 240, height: 230)
                .frame(maxWidth: .infinity, alignment: .center)

            VStack(spacing: 20) {
                AttachmentBarRow(
                    title: "애착 불안",
                    result: anxietyResult
                )

                AttachmentBarRow(
                    title: "애착 회피",
                    result: avoidanceResult
                )
            }
        }
    }
}

private struct AttachmentDescriptionSection: View {

    let userName: String
    let attachmentType: AttachmentType
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            HStack(spacing: 4) {
                Text("\(userName)님의 애착유형은")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)

                Text("‘\(attachmentType.title)’")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(attachmentType.titleColor)

                Text("입니다.")
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(.gray900)
            }

            Text(description)
                .font(.PretendardRegular(size: 12))
                .foregroundStyle(.gray900)
                .lineSpacing(4)
        }
       
    }
}
        
private struct AttachmentBarRow: View {

    let title: String
    let result: AttachmentBarResult

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            // 제목 + 점수
            HStack(spacing: 4) {
                Text("\(title):")
                    .font(.PretendardSemiBold(size: 14))
                    .foregroundStyle(.gray900)

                Text("\(result.score)")
                    .font(.PretendardRegular(size: 14))
                    .foregroundStyle(.gray900)
            }

            // 프로그레스 바
            ProgressBarView(
                ratio: result.ratio,
                barColor: result.color
            )
            .frame(width: 305, height: 12)
            
        }
        .padding(.leading)
    }
}

private struct ProgressBarView: View {

    let ratio: Double
    let barColor: Color

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading) {

                // 배경 바
                Capsule()
                    .fill(Color.gray.opacity(0.15))

                // 채워지는 바
                Capsule()
                    .fill(barColor)
                    .frame(
                        width: max(geo.size.width * ratio, 6)
                    )
            }
        }
        .frame(height: 12)
    }
}
        
