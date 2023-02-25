////
//  PermissionProvider.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 18.02.2023.
//

import Foundation
import AppKit
import UniformTypeIdentifiers

private extension String {
    static let bookmarksDataKey = "bookmarksDataKey"
}

final class FilePermissionManager {
    
    private let userDefaults = UserDefaults.standard
    
    static let shared = FilePermissionManager()
    
    private init() {}
    
    // MARK: Logic
    
    private var storedBookmarks: [Data] {
        userDefaults.object(forKey: .bookmarksDataKey) as? [Data] ?? []
    }
    
    func getPermittedURLs() throws -> [URL] {
        // Update stale bookmarks
        for bookmarkData in storedBookmarks {
            var isStale = false
            let url = try URL(resolvingBookmarkData: bookmarkData,
                              options: [],
                              relativeTo: nil,
                              bookmarkDataIsStale: &isStale)
            
            if isStale {
                print("Bookmark with path: \(url.path) is stale, trying to recreate it")
                try removeBookmarkData(for: url)
                try addBookmarkDataToStorage(for: url)
            }
        }
        
        // Return updated bookmarks
        return try storedBookmarks.map {
            var isStale = false
            let url = try URL(resolvingBookmarkData: $0,
                              options: [],
                              relativeTo: nil,
                              bookmarkDataIsStale: &isStale)
            assert(!isStale, "url \(url.path) is still stale after update")
            
            return url
        }
    }
    
    func addBookmarksDataToStorage(for urls: [URL]) throws {
        let bookmarksData = try convertURLsToBookMarkData(urls)
        
        var storedBookmarks = storedBookmarks
        let set = Set<Data>(storedBookmarks)
        for bookmarkData in bookmarksData {
            if set.contains(bookmarkData) {
                continue
            }
            storedBookmarks.append(bookmarkData)
        }
        
        userDefaults.set(storedBookmarks, forKey: .bookmarksDataKey)
    }
    
    func addBookmarkDataToStorage(for url: URL) throws {
        try addBookmarksDataToStorage(for: [url])
    }
    
    func removeBookmarkData(for url: URL) throws {
        let urls = try storedBookmarks
            .map {
                var isStale = false
                return try URL(resolvingBookmarkData: $0, options: [], relativeTo: nil, bookmarkDataIsStale: &isStale)
            }
            .filter { $0 != url }
        
        userDefaults.set(try convertURLsToBookMarkData(urls), forKey: .bookmarksDataKey)
    }
    
    func resolvePermissions(canChooseFiles: Bool,
                            canChooseDirectories: Bool,
                            title: String? = nil,
                            allowedContentTypes: [UTType] = [.yaml]) -> URL? {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = canChooseFiles
        openPanel.canChooseDirectories = canChooseDirectories
        openPanel.allowsOtherFileTypes = false
        openPanel.allowedContentTypes = [.yaml]
        openPanel.allowsMultipleSelection = false
        openPanel.showsHiddenFiles = true
        if let title {
            openPanel.title = title
        }
        
        if openPanel.runModal() == .OK {
            return openPanel.urls.first
        }
        
        return nil
    }
    
    // MARK: Helpers
    
    private func convertURLsToBookMarkData(_ urls: [URL]) throws -> [Data] {
        return try urls.map {
            try $0.bookmarkData(options: [],
                                includingResourceValuesForKeys: nil,
                                relativeTo: nil)
        }
    }
}
