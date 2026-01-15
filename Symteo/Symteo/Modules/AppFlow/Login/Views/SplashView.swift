//
//  SplashView.swift
//  Symteo
//
//  Created by 김지우 on 1/9/26.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack(alignment:.center){
            Color.maingreen
                .ignoresSafeArea()
                .edgesIgnoringSafeArea(.all)
            
            Image(.symlogo)
            
            }
        }
        
    }


#Preview {
    SplashView()
}
