//
//  TestBaseView.swift
//  Symteo
//
//  Created by 김지우 on 1/18/26.
//

import SwiftUI



struct TestBaseView: View {
    let data: TestCategoryModel
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        ScrollView {
            VStack(alignment:.center, spacing: 0) {
                
                Spacer()
                
                HStack {
                    CustomBackButton { dismiss() }
                    Spacer()
                }
                .padding(.top, 48)
                .padding(.bottom,12)
                .padding(.horizontal)
                
                
                VStack {
                    
                    Spacer()
                        .frame(height:37)
                    
                    //검사 이름
                    Text(data.title)
                        .font(.PretendardSemiBold(size: 14))
                        .foregroundStyle(Color(.gray600))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color.white))
                    
                    Spacer()
                        .frame(height:16)
                    
                    //검사 설명 질문
                    Text(data.description)
                        .font(.PretendardSemiBold(size: 22))
                        .foregroundStyle(Color(.gray900))
                        .multilineTextAlignment(.center)
                        .lineSpacing(10)
                    
                    //검사 이미지
                    Image(data.mainImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 253)
                    
                    //검사 소요 시간
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .foregroundStyle(Color.gray900)
                        Text(data.infoText)
                            .font(.PretendardRegular(size: 12))
                            .foregroundStyle(Color.gray600)

                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.5)))
                    
                    Spacer()
                        .frame(height:24)
                    
                    //검사 시작 버튼
                    Button(action: { }) {
                        Text(data.startButtonTitle)
                            .font(.PretendardSemiBold(size: 16))
                            .foregroundStyle(.gray900)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 20)
                    
                    
                    Spacer()
                        .frame(height:8)
                    
                    //검사 주의사항
                    Text(data.caution)
                        .font(.PretendardRegular(size: 12))
                        .foregroundStyle(.gray400)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 24)

                    
                }
                .background(Color(data.themeColor))
                
                VStack(alignment: .leading) {
                    
                    Spacer()
                        .frame(height:22)
                    Text("혹시 이런 고민 하고 있나요?")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(.gray900)
                    
                    Spacer()
                        .frame(height:16)
                    
                    // 질문과 이모지 배열 매칭
                    ForEach(0..<data.questions.count, id: \.self) { index in
                        HStack(spacing:4) {
                            if index < data.emojis.count {
                                Image(data.emojis[index])
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            }
                            Text(data.questions[index])
                                .font(.PretendardRegular(size: 14))
                                .foregroundStyle(.gray900)
                            Spacer()
                        }
                        .padding()
                        .background(Color(.white))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.03), radius: 4, x: 0, y: 6)
                        
                    }
                    
                    Spacer()
                        .frame(height:24)
                    //검사 추천
                    Text("이런 검사는 어떠신가요?")
                        .font(.PretendardSemiBold(size: 16))
                        .foregroundStyle(.gray900)
                    
    
                    ScrollView(.horizontal,showsIndicators:false){
                        HStack(spacing:20) {
                            ForEach(data.recommendations){item in
                                Button(action:{
                                    container.navigationRouter.push(item.destination)
                                }){
                                    HStack(spacing:8){
                                        Image(item.icon)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width:28,height:28)
                                        
                                        Text(item.title)
                                                                    .font(.PretendardSemiBold(size: 14))
                                                                    .foregroundStyle(.gray900)
                                        
                                        Image(systemName: "chevron.right")
                                                                    .font(.system(size: 12, weight: .bold))
                                                                    .foregroundStyle(.gray400)
                                    }
                                    .padding(.horizontal, 16)
                                                        .padding(.vertical, 18)
                                                        .background(Color.white)
                                                        .cornerRadius(12)
                                                        // 투명도 3%의 아주 연한 그림자
                                                        .shadow(color: Color.black.opacity(0.03), radius: 10, x: 0, y: 6)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarHidden(true)
    }
}

#Preview {
    TestBaseView(data: TestCategoryViewModel().depressionTest)
}
