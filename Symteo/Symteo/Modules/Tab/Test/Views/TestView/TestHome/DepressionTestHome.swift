//
//  DepressionTestHome.swift
//  Symteo
//
//  Created by 김지우 on 1/18/26.
//

import SwiftUI

struct DepressionTestHome: View {
    
    @StateObject private var viewModel = TestCategoryViewModel()
    
    var body: some View {
        TestBaseView(data: viewModel.depressionTest)}
}

#Preview {
    DepressionTestHome()
}
