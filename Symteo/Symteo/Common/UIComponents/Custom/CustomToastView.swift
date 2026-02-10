//
//  CustomToastView.swift
//  Symteo
//
//  Created by 박병선 on 2/9/26.
//
import SwiftUI

struct CustomToastView: View {
    var title: String
    var message: String
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.PretendardSemiBold(size: 14))
                        .foregroundStyle(.white)
                    
                    Text(message)
                        .font(.PretendardRegular(size: 12))
                        .foregroundStyle(.white)
                }
                
                Spacer(minLength: 10)
                
                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.white)
                }
            }
            .padding()
        }
        .background(Color.black.opacity(0.6))
        .frame(minWidth: 0, maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 32)
    }
}

