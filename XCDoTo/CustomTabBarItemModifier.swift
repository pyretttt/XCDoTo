////
//  CustomTabBarItemModifier.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 05.02.2023.
//

import SwiftUI

struct CustomTabBarItem<TabView: View>: ViewModifier {
    
    @Environment(\.selectedTab) private var selectedTab: CustomTabBarPreference?
    
    let tabView: () -> TabView
    private let id: Int
    
    init(id: Int, @ViewBuilder tabView: @escaping () -> TabView) {
        self.id = id
        self.tabView = tabView
    }

    func body(content: Content) -> some View {
        Group {
            if selectedTab == nil {
                content
            } else if selectedTab?.id == id {
                content
            } else {
                Color.clear.frame(width: 0, height: 0)
            }
        }
        .frame(maxWidth: selectedTab?.id == id ? nil : .zero,
               maxHeight: selectedTab?.id == id ? .infinity : .zero)
        .preference(
            key: CustomTabBarPreferenceKey.self,
            value: [CustomTabBarPreference(id: id, tabView: AnyView(tabView()))]
        )
    }
}

extension View {
    func customTabItem(id: Int, @ViewBuilder content: @escaping () -> some View) -> some View {
        return self.modifier(CustomTabBarItem(id: id, tabView: content))
    }
}
