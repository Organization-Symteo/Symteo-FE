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

                    // MARK: -진단 화면
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
                        SurveyView(kind: kind, container: container)
                            .environmentObject(container)
                        
                    // MARK: -리포트 화면
                    case let .anxietyReport(reportId):
                        AnxietyReportView(reportId: reportId,container: container)
                            .environmentObject(container)

                    case let .stressReport(reportId):
                        StressReportView(reportId: reportId,container: container)
                            .environmentObject(container)
                  

                    case let .attachmentReport(reportId):
                        AttachmentReportView(reportId: reportId,container: container)
                            .environmentObject(container)

                    // MARK: -마이심터 화면 
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
                        CounselSettingView(usage:.myEdit)
                    }
                }
        }
    }
    
}

#Preview {
    NavigationRoutingView()
        .environmentObject(DIContainer())
}
