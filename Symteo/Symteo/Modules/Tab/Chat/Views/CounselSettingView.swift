//
//  CounselSettingView.swift
//  Symteo
//
//  Created by 김지우 on 2/5/26.
//

import SwiftUI


struct CounselSettingView: View {
    @StateObject private var viewModel = CounselSettingViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            customHeader
            
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    
                    Text("내게 맞는 상담 스타일을 설정해보세요")
                        .font(.PretendardRegular(size: 14))
                        .foregroundStyle(.gray400)
                        .padding(.top, 10)
                    
                    ForEach(viewModel.sections) { section in
                        CounselSectionComponent(
                            section: section,
                            viewModel: viewModel
                        )
                    }
                    
                    Spacer().frame(height: 50)
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            
            saveButton
        }
        .navigationBarHidden(true)
        .background(Color.white)
    }
    

    
    private var customHeader: some View {
        ZStack(alignment: .leading){
            
            Button(action: { dismiss() }) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.black)
            }
            .padding(.trailing, 4)
            
            
           
            HStack{
                Text("맞춤")
                    .font(.PretendardBold(size: 11))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.green400)
                    .cornerRadius(12)
                
                Text("상담사 설정")
                    .font(.PretendardMedium(size: 16))
                    .foregroundStyle(.black)
            }
            .frame(maxWidth: .infinity)

            
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .overlay(Rectangle().frame(height: 1).foregroundStyle(.gray100), alignment: .bottom)
    }
    
    private var saveButton: some View {
        Button(action: {
            viewModel.saveSettings()
            dismiss()
        }) {
            Text("저장")
                .font(.PretendardMedium(size: 16))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Color.green400)
                .cornerRadius(12)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 10)
    }
}

// MARK: - 섹션 컴포넌트
struct CounselSectionComponent: View {
    let section: CounselSection
    @ObservedObject var viewModel: CounselSettingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            // 섹션 제목
            Text(section.title)
                .font(.PretendardSemiBold(size: 14))
                .foregroundStyle(.gray900)
            
            // 옵션 버튼들 (가로 스크롤/나열)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(section.options, id: \.self) { option in
                        OptionButton(
                            text: option,
                            isSelected: viewModel.isSelected(sectionTitle: section.title, option: option),
                            action: {
                                viewModel.toggleOption(
                                    sectionTitle: section.title,
                                    option: option,
                                    isMultiSelect: section.isMultiSelect
                                )
                            }
                        )
                    }
                }
            }
        }
    }
}



#Preview {
    CounselSettingView()
}

