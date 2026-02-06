//
//  BaseTabView.swift
//  Symteo
//
//  Created by 김지우 on 1/8/26.
//

import SwiftUI

struct BaseTabView: View {
    
    /// 의존성 주입을 위한 DI 컨테이너
    @EnvironmentObject var container: DIContainer
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $container.selectedTab) {
                ForEach(TabItem.allCases, id: \.rawValue) { tab in
                    Tab(
                        tab.title,
                        image: container.selectedTab == tab ? "\(tab.rawValue)_fill" : "\(tab.rawValue)",
                        value: tab,
                        content: {
                            tabView(tab: tab)
                        }
                    )
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
    
    //각 탭에 해당하는 뷰
    @ViewBuilder
    private func tabView(tab: TabItem) -> some View {
        Group {
            switch tab {
            case .home:
                HomeView()
                    .environmentObject(container)
            case .chat:


                ChatView(container: container)
            case .profile:

                EmptyView()
            case .test:
                EmptyView()
            case .report:
                EmptyView()

            case .profile:
                MySymteoView()
              

               

            }
        }
        .environmentObject(container)
        
    }
}

#Preview {
    BaseTabView()
        .environmentObject(DIContainer())

}
