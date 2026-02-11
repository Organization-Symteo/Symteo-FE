//
//  NavigationRoutingView.swift
//  Symteo
//
//  Created by 김지우 on 1/8/26.
//

import SwiftUI

struct NavigationRoutingView: View {
    @EnvironmentObject var container: DIContainer

    var body: some View {
        NavigationStack(path:$container.navigationRouter.path){
            
            //Tab 뷰
            BaseTabView()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {

                    case .setting:
                        SettingView()

                    case .privacy:
                        PrivacyPolicyView()

                    case .service:
                        ServicePolicyView()
                        
                    case .home:
                        HomeView(container: container)
                    case .mission:
                        MissionView(container: container)
                    }
                }
        }
    }
}

#Preview {
    NavigationRoutingView()
        .environmentObject(DIContainer())
}
