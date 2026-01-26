//
//  AttachmentTypeSection.swift
//  Symteo
//
//  Created by 박병선 on 1/22/26.
//
import SwiftUI

struct AttachmentTypeSection: View {
    let type: AttachmentType
    
    var body: some View {
        HStack(spacing: 8) {
            
            Image(type.image)
                .resizable()
                .frame(width: 48, height: 48)

            HStack(spacing: 2) {
                Text("나의 애착 유형:")
                    .font(.PretendardMedium(size: 16))
                    .foregroundStyle(.gray900)
                
                Text(type.title)
                    .font(.PretendardSemiBold(size: 16))
                    .foregroundStyle(type.titleColor)
            }

            Spacer() 
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading) // 카드 가로 꽉
        .background(type.backgroundColor)
        .cornerRadius(16)
    }
}

#Preview {
    AttachmentTypeSection(type: .anxious)
}
