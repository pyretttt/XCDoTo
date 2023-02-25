////
//  CustomTabBarView.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 04.02.2023.
//

import SwiftUI

// MARK: Views

struct CustomTabBarView<Content: View>: View {
    
    @ViewBuilder let content: () -> Content
    
    @State private var tabItems: [CustomTabBarPreference] = []
    @State private var selectedTab: Int = 0
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: .zero) {
            HStack {
                let _ = CustomTabBarView._printChanges()
                ForEach(0..<tabItems.count, id: \.self) { idx in
                    tabItems[idx].tabView
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.2)) {
                                selectedTab = idx
                            }
                        }
                        .foregroundColor(selectedTab == idx ? .blue : .white)
                    if idx != tabItems.count - 1 {
                        Spacer()
                    }
                }
            }
            .padding(EdgeInsets(top: 8, leading: 24, bottom: 8, trailing: 24))
            
            content()
        }
        .onPreferenceChange(CustomTabBarPreferenceKey.self) { tabs in
            self.tabItems = tabs
        }
        .environment(\.selectedTab, tabItems.count > 0 ? tabItems[selectedTab] : nil)
    }
}

// MARK: Preview

struct CustomTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBarView {
        }
    }
}

