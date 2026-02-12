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
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        // 텍스트 비선택(회색)
        appearance.stackedLayoutAppearance.normal.iconColor = .systemGray2
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.systemGray2
        ]

        // 텍스트 선택(검정)
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $container.selectedTab) {
                ForEach(TabItem.allCases, id: \.rawValue) { tab in
                    Tab(
                        tab.title,
                        image: container.selectedTab == tab ? "\(tab.rawValue)fill" : "\(tab.rawValue)",
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
            case .test:
                TestHomeView()
                    .environmentObject(container)
            case .profile:
                MySymteoView()
             case .chat:
                ChatView(container: container)
            case .report:
                MainReportView(userName: "따오기", container: container)


            }
        }
        .environmentObject(container)
        
    }
}

#Preview {
    BaseTabView()
        .environmentObject(DIContainer())

}
