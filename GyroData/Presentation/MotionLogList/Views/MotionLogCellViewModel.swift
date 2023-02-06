//
//  MotionLogCellViewModel.swift
//  GyroData
//
//  Copyright (c) 2023 Jeremy All rights reserved.
    

import Foundation

struct MotionLogCellViewModel: Hashable, Equatable {
    let createDate: String
    let title: String
    let runTime: String
    let id: UUID
    
    init(createDate: Date, title: String, runTime: Double) {
        self.createDate = createDate.formattedToString()
        self.title = title
        self.runTime = String(runTime)
        self.id = UUID()
    }
    
    public static func == (lhs: MotionLogCellViewModel, rhs: MotionLogCellViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}

fileprivate extension Date {
    func formattedToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }
}
