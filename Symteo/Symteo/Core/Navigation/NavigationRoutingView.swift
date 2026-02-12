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
        NavigationStack(path: $container.navigationRouter.path) {
            BaseTabView()
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {

                    case .basetab:
                        BaseTabView()
                            .environmentObject(container)

                    case .depressionTest:
                        DepressionTestHome()
                            .environmentObject(container)

                    case .typeTest:
                        TypeTestHome()
                            .environmentObject(container)

                    case .stressTest:
                        StressTestHome()
                            .environmentObject(container)

                    case let .survey(kind):
                        SurveyView(kind: kind)
                            .environmentObject(container)

                        
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



                    case .counselsetting:
                        CounselSettingView()
                    }
                }
        }
    }
    
}

#Preview {
    NavigationRoutingView()
        .environmentObject(DIContainer())
}
