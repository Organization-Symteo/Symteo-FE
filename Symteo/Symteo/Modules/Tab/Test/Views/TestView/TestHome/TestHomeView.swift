//
//  TestHomeView.swift
//  Symteo
//
//  Created by 김지우 on 1/12/26.
//

import SwiftUI
import Combine

struct TestHomeView: View {
    
    /// 의존성 주입을 위한 DI 컨테이너
    @EnvironmentObject var container: DIContainer
    @State private var viewModel = TestHomeViewModel()
    
    var body: some View {
        ScrollView{
            VStack(alignment:.leading){
                header

                ForEach(viewModel.testList) { item in
                    Button {
                        
                        routeToDetail(item)
                        
                    } label: {
                        
                        TestCard(data: item)
                        
                    }
                    
                    .buttonStyle(PlainButtonStyle())
                    
                }
            }
            .padding()
            
        }
    }
    
    
    private var header: some View{
        VStack(alignment: .leading){
            Text("심터 진단:")
                .font(.PretendardSemiBold(size: 16))
            
            Text("오늘의 나를 마주하는 시간")
                .font(.PretendardMedium(size: 20))
            
        }
    }
    
    private func routeToDetail(_ item: TestModel) {
            switch item.icon {
            case "depressionlogo":
                container.navigationRouter.push(.depressionTest)
            case "stresslogo":
                container.navigationRouter.push(.stressTest)
            case "typelogo":
                container.navigationRouter.push(.typeTest)
            default:
                break
            }
        }
    
}

#Preview {
    TestHomeView()
}
