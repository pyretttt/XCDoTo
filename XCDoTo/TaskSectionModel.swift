////
//  TaskSectionModel.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 22.02.2023.
//

import Foundation

struct TaskSectionModel: Identifiable, Equatable, Codable {
    
    /// Should be unique, duplicates aren't allowed
    let path: String
    var title: String
    var isDisclosed: Bool
    var tasks: [TaskModel]
    
    var id: String { path }
}

extension TaskSectionModel {
    static func new(title: String,
                    path: String,
                    isDisclosed: Bool = true,
                    tasks: [TaskModel] = []) -> Self {
        return TaskSectionModel(path: path, title: title, isDisclosed: isDisclosed, tasks: tasks)
    }
    
    static let empty = TaskSectionModel(path: "", title: "", isDisclosed: true, tasks: [])
}
