////
//  YamlFileCodec.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 17.02.2023.
//

import Foundation
import Yams

struct YamlFileCodec {
    
    private let fm = FileManager.default
    
    private let encoder = YAMLEncoder()
    private let decoder = YAMLDecoder()
    
    // MARK: Interaction
    
    func load<D: Decodable>(from filePath: String) throws -> D {
        guard let data = fm.contents(atPath: filePath) else {
            throw XCDoTOError.fileReadingError(filePath: filePath)
        }
        
        let model = try decoder.decode(D.self, from: data)
        
        return model
    }
    
    func urlSecureLoad<D: Decodable>(from url: URL) throws -> D {
        let result: D = try urlSecurityAccess(for: url) {
            return try load(from: url.path)
        }
        
        return result
    }
    
    func dump<E: Encodable>(_ object: E, filePath: String) throws {
        let data = try encoder.encode(object).data(using: .utf8)
        fm.createFile(atPath: filePath, contents: data)
    }
    
    func urlSecureDump<E: Encodable>(_ object: E, url: URL) throws {
        try urlSecurityAccess(for: url) {
            try dump(object, filePath: url.path)
        }
    }
    
    private func urlSecurityAccess<Result>(for url: URL, job: () throws -> Result) rethrows -> Result {
        defer { url.stopAccessingSecurityScopedResource() }
        if !url.startAccessingSecurityScopedResource() {
            print("Failed to securely access \(url.path), that may be due to unnecessary of access")
        }
        
        return try job()
    }
}
