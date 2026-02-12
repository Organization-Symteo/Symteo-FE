//
//  RoundedCorner.swift
//  Symteo
//
//  Created by 박병선 on 1/21/26.
//

import SwiftUI

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
/*
 private struct RoundedCorner: Shape {
     var radius: CGFloat
     var corners: UIRectCorner

     func path(in rect: CGRect) -> Path {
         let path = UIBezierPath(
             roundedRect: rect,
             byRoundingCorners: corners,
             cornerRadii: CGSize(width: radius, height: radius)
         )
         return Path(path.cgPath)
     }
 }
 */
