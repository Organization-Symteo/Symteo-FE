//
//  ReportItem.swift
//  Symteo
//
//  Created by 박병선 on 1/18/26.
//
import Foundation

struct ReportItem: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let fullImageName: String
    let type: ReportType
}


