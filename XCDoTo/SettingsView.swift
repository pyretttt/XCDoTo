////
//  SettingsView.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 19.02.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var settingsFacade: SettingsFacade
    @State private var selectedURL: URL?
    
    // MARK: View
    
    private var locationsSection: some View {
        Section(settingsFacade.permittedLocations.isEmpty ? "No Located Files" : "Locations") {
            VStack {
                ForEach(settingsFacade.permittedLocations, id: \.path) { url in
                    HStack() {
                        Text(url.path)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color(nsColor: NSColor.fromHEX(0xFFFFFF).withAlphaComponent(0.8)))
                        Spacer()
                    }
                    .padding(4)
                    .background(selectedURL == url ? Color.accentBlue : Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedURL = url
                    }
                }
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical) {
                locationsSection
            }
            
            Divider.appStyled()
            
            SettingsFooter(selectedURL: $selectedURL)
        }
        .onTapGesture {
            selectedURL = nil
        }
        .task {
            do {
                try settingsFacade.load()
            } catch {
                print(error.localizedDescription, #file, #function, #line)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
