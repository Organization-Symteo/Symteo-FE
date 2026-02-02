//
//  AttachmentType.swift
//  Symteo
//
//  Created by 박병선 on 1/26/26.
//
import SwiftUI

enum AttachmentType {
    case anxious        // 불안형
    case secure         // 안정형
    case fearfulAvoidant // 공포 회피형
    case dismissiveAvoidant // 거부 회피형
}

extension AttachmentType {

    var title: String {
        switch self {
        case .anxious: return "불안형"
        case .secure: return "안정형"
        case .fearfulAvoidant: return "공포 회피형"
        case .dismissiveAvoidant: return "거부 회피형"
        }
    }

    var titleColor: Color {
        switch self {
        case .anxious: return Color(hex:"#ED3F36")
        case .secure: return Color(hex:"#2C9B03")
        case .fearfulAvoidant: return Color(hex:"#8754DC")
        case .dismissiveAvoidant: return Color(hex:"#1F89E0")
        }
    }

    var backgroundColor: Color {
        switch self {
        case .anxious: return Color(hex: "#FFEBEA")
        case .secure: return Color(hex: "#E6F7E0")
        case .fearfulAvoidant: return Color(hex: "#E2DAEF")
        case .dismissiveAvoidant: return Color(hex: "#E7F1F9")
        }
    }

    var image: String {
        switch self {
        case .anxious: return "attachment_red"
        case .secure: return "attachment_green"
        case .fearfulAvoidant: return "attachment_purple"
        case .dismissiveAvoidant: return "attachment_blue"
        }
    }
}
