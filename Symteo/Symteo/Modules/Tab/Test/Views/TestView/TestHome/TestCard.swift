//
//  TestCard.swift
//  Symteo
//
//  Created by 김지우 on 1/17/26.
//

import SwiftUI

struct TestCard: View {
    let data: TestModel
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius:12)
                .fill(Color.white)
                .frame(width:344,height:105)
            
            HStack{
                Image(data.icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width:60,height:60)
                
                Spacer()
                    .frame(width:12)
                    
                textContent
                
                Spacer()
                    
                
                Image(.chevronicon)
                    .frame(width:9,height:12)
                
                Spacer()
                    .frame(width:4)

            }
            .padding(.horizontal,40)
        }
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
    }
    
    private var textContent: some View{
        VStack(alignment:.leading){
            Text(data.title)
                .font(.PretendardSemiBold(size: 18))
            
            Spacer()
                .frame(height:4)
            Text(data.subtitle)
                .font(.PretendardRegular(size: 12))
                .foregroundStyle(Color.gray700)
            
            Spacer()
                .frame(height:4)
            
            ZStack{
                RoundedRectangle(cornerRadius:12)
                    .fill(Color.gray5)
                    .frame(width:55,height:21)
                
                Text(data.testtime)
                    .font(.PretendardRegular(size: 12))
                    .foregroundStyle(Color.gray700)

                

            }
        }
    }
}

#Preview {
    TestCard(data:TestHomeViewModel().testList[0])
}
