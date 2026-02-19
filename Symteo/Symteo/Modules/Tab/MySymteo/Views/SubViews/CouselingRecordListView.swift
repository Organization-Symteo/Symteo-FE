//
//  CouselingRecordView.swift
//  Symteo
//
//  Created by 박병선 on 2/7/26.
//
import SwiftUI

import SwiftUI

struct CounselingRecordListView: View {

    @StateObject private var viewModel = CounselingRecordListViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {

                    if viewModel.isLoading {
                        ProgressView().padding(.top, 20)
                    }

                    if let err = viewModel.errorMessage {
                        Text(err)
                            .font(.PretendardMedium(size: 12))
                            .foregroundStyle(.red)
                            .padding(.top, 12)
                    }

                    ForEach(viewModel.records.prefix(10)) { record in
                        CounselingRecordCell(record: record)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .frame(width: .infinity)

                    Text("최근 내역 10개까지 볼 수 있어요.")
                        .font(.PretendardMedium(size: 12))
                        .foregroundStyle(.gray600)
                        .padding(.top, 8)
                }
                .padding()
            }
            .onAppear {
                viewModel.load()
            }
        }
    }
}


struct CounselingRecordCell: View {
    
    let record: CounselingRecord
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                
                Text(record.date)
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(.gray500)
                
                Text(record.title)
                    .font(.PretendardMedium(size: 14))
                    .foregroundStyle(.gray900)
            }
            
            Spacer()
            
            /// chevron 버튼
            NavigationLink {
                CounselingDetailView(record: record)
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.gray700)
                    .padding(.top)
                    .buttonStyle(.plain)
                    .padding(.vertical, 20)
                    .frame(minHeight: 80)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
            .shadow(color: Color.black.opacity(0.04),radius: 12,x: 0,y: 6)
        }
    }
}

#Preview("Counseling Record List") {
    CounselingRecordListView()
}
