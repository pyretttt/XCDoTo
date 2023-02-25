////
//  XCDoToApp.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 25.12.2022.
//

import SwiftUI

@main
struct XCDoToApp: App {
    
    var body: some Scene {
        WindowGroup {
            EntryView()
                .frame(minWidth: 416, maxWidth: .infinity, minHeight: 700, maxHeight: .infinity)
                .environmentObject(TaskRepository())
                .environmentObject(SettingsFacade())
        }
        .windowStyle(.hiddenTitleBar)
    }
}
