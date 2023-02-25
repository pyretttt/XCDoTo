////
//  EntryView.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 25.12.2022.
//

import SwiftUI

struct EntryView: View {
    
    @EnvironmentObject private var tasksRepository: TaskRepository
    
    var body: some View {
        CustomTabBarView {
            Divider.appStyled()
            
            TaskListView()
                .customTabItem(id: 0) {
                    Image(systemName: "folder.fill")
                        .resizable()
                        .frame(width: 20, height: 16)
                }
            
            SettingsView()
                .customTabItem(id: 1) {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
        }
        .background(BlurView(material: .fullScreenUI))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
