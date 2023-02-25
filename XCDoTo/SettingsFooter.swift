////
//  SettingsFooter.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 19.02.2023.
//

import SwiftUI

struct SettingsFooter: View {
    
    @EnvironmentObject private var settingsFacade: SettingsFacade
    @Binding private(set) var selectedURL: URL?
    
    init(selectedURL: Binding<URL?>) {
        self._selectedURL = selectedURL
    }
    
    // MARK: Views
        
    var body: some View {
        HStack(spacing: 6) {
            buttonEntity(imageSystemName: "folder.badge.plus") {
                do {
                    try settingsFacade.createProject()
                } catch {
                    print(error.localizedDescription, #file, #function, #line)
                }
            }
            
            buttonEntity(imageSystemName: "arrow.up.doc") {
                do {
                    try settingsFacade.addExistingProject()
                } catch {
                    print(error.localizedDescription, #file, #function, #line)
                }
            }
            
            buttonEntity(imageSystemName: "trash") {
                do {
                    if let selectedURL {
                        try settingsFacade.removeProject(with: selectedURL)
                    }
                } catch {
                    print(error.localizedDescription, #file, #function, #line)
                }
            }
            .disabled(selectedURL == nil)
            
            Spacer()
        }
        .buttonStyle(.borderless)
    }
    
    private func buttonEntity(imageSystemName: String, action: @escaping () -> Void) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: imageSystemName)
                .padding(8)
        }
    }

}
