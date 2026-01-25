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
                .environmentObject(container)
                .navigationDestination(for: NavigationDestination.self) { destination in
                
                    Group{
                        switch destination{
                            
                        case .basetab:
                            BaseTabView()
                            
                        case .depressionTest:
                            DepressionTestHome()
                            
                        case .typeTest:
                            TypeTestHome()

                        case .stressTest:
                            StressTestHome()

                        }
                    }
                }
        }
        .environmentObject(container)
    }
}

#Preview {
    NavigationRoutingView()
        .environmentObject(DIContainer())
}
