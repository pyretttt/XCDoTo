////
//  SourceEditorCommand.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 25.02.2023.
//

import Foundation
import XcodeKit
import AppKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    func perform(with invocation: XCSourceEditorCommandInvocation,
                 completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard let url = URL(string: "xcdoto://") else { return }
        NSWorkspace.shared.open(url, configuration: .init()) { _, err in
            completionHandler(err)
        }
    }
}
