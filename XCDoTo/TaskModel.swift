////
//  TaskModel.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 03.01.2023.
//

import Foundation

struct TaskModel: Identifiable, Hashable, Codable {
    let id: UUID
    
    var title: String
    var release: String
    var author: String
    var priority: PriorityModel
    var taskDescription: String
    
    func trimmed() -> TaskModel {
        var copy = self
        copy.title = title.trimmingCharacters(in: .whitespacesAndNewlines)
        copy.release = release.trimmingCharacters(in: .whitespacesAndNewlines)
        copy.author = author.trimmingCharacters(in: .whitespacesAndNewlines)
        copy.taskDescription = taskDescription.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return copy
    }
}

extension TaskModel {
    static func new(title: String, uuid: UUID = UUID()) -> TaskModel {
        TaskModel(id: uuid,
                  title: title,
                  release: "",
                  author: "",
                  priority: .normal,
                  taskDescription: "")
    }
    
    static let empty = Self.new(title: "")
}
