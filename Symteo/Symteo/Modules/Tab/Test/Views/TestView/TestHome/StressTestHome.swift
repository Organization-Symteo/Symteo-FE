//
//  StressTestHome.swift
//  Symteo
//
//  Created by 김지우 on 1/18/26.
//

import SwiftUI

struct StressTestHome: View {
    @StateObject private var viewModel = TestCategoryViewModel()
    
    var body: some View {
        TestBaseView(data: viewModel.stressTest)    }
}

#Preview {
    StressTestHome()
}
