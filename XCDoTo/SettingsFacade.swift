////
//  SettingsFacade.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 19.02.2023.
//

import SwiftUI

final class SettingsFacade: ObservableObject {
    
    @Published private(set) var permittedLocations: [URL] = []
    
    private let filePermissionProvider: FilePermissionManager
    private let yamlFileCodec = YamlFileCodec()
    
    init(filePermissionProvider: FilePermissionManager = FilePermissionManager.shared) {
        self.filePermissionProvider = filePermissionProvider
    }
    
    func load() throws {
        permittedLocations = try filePermissionProvider.getPermittedURLs()
    }
    
    func addExistingProject() throws {
        guard let url = filePermissionProvider.resolvePermissions(canChooseFiles: true,
                                                                  canChooseDirectories: false,
                                                                  title: "Add existing .YAML file") else { return }
        try filePermissionProvider.addBookmarkDataToStorage(for: url)
        try load()
    }
    
    func createProject() throws {
        guard let url = filePermissionProvider.resolvePermissions(
            canChooseFiles: false,
            canChooseDirectories: true,
            title: "Choose directory where to create project file") else {
            return
        }
        
        let fileURL = url.appendingPathComponent(".XCDoTo.yaml")
        let filePath = fileURL.path
        try yamlFileCodec.dump(TaskSectionModel.new(title: "New Project", path: filePath), filePath: filePath)
        try filePermissionProvider.addBookmarkDataToStorage(for: fileURL)
        try load()
    }
    
    func removeProject(with url: URL) throws {
        try filePermissionProvider.removeBookmarkData(for: url)
        try load()
    }
}
