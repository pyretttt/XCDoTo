////
//  TaskRepository.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 03.01.2023.
//

import Foundation

final class TaskRepository: ObservableObject {
    
    // State
    @Published private(set) var sections: [TaskSectionModel] = []
    @Published var searchPattern: String = ""
    
    // Dependencies
    private let fileCodec = YamlFileCodec()
    private let filePermissionProvider = FilePermissionManager.shared
    
    // MARK: Methods
    
    func searchedSection() -> [TaskSectionModel] {
        if searchPattern.isEmpty {
            return sections
        }
        let sectionsCopy = sections
        let searchPatter = searchPattern.lowercased()
        return sectionsCopy
            .map { // We should disclose every section
                var copy = $0
                copy.isDisclosed = true
                copy.tasks = copy.tasks.filter {
                    let index = [$0.title, $0.taskDescription, $0.author, $0.release, $0.priority.rawValue]
                        .map { $0.lowercased() }
                        .first { $0.contains(searchPatter) }
                    return index != nil
                }
                
                return copy
            }
            .filter { $0.title.lowercased().contains(searchPatter) || !$0.tasks.isEmpty }
    }
    
    func load() {
        var sections: [TaskSectionModel] = []
        let urls = (try? filePermissionProvider.getPermittedURLs()) ?? []
        
        for url in urls {
            if let section: TaskSectionModel = try? fileCodec.urlSecureLoad(from: url) {
                sections.append(section)
            }
        }
        
        self.sections = sections
    }
    
    func createNewTask(sectionIdentifier: TaskSectionModel.ID) -> TaskModel {
        guard let index = sections.firstIndex(where: { $0.id == sectionIdentifier }) else {
            assert(false, "attempt to create task in non existing section")
        }
        
        let task = TaskModel.new(title: "")
        sections[index].tasks.append(task)
        
        persistSection(sections[index])
        
        return task
    }
    
    func editSection(_ section: TaskSectionModel) {
        guard let sectionIndex = sections.firstIndex(where: { $0.id == section.id }) else {
            assert(false, "attempt to edit non existing task or non existing section")
        }
        
        persistSection(section)
        sections[sectionIndex] = section
    }
    
    private func persistSection(_ section: TaskSectionModel) {
        do {
            try fileCodec.dump(section, filePath: section.path)
        } catch {
            print(error.localizedDescription)
            assert(false, "failed to update file \(section.path)")
        }
    }
}
