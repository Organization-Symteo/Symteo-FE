//
//  CounselingRecord.swift
//  Symteo
//
//  Created by 박병선 on 2/7/26.
//
import Foundation


struct CounselingRecord : Identifiable{
    let id = UUID()
    let date: String
    let title: String
    let emotion: String
    let userContent: String
    let aiResponse: String
}
