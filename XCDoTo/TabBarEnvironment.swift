////
//  TabBarEnvironment.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 05.02.2023.
//

import SwiftUI

// MARK: Environment

struct CustomTabBarEnvironmentKey: EnvironmentKey {
    static var defaultValue: CustomTabBarPreference? = nil
}

extension EnvironmentValues {
    var selectedTab: CustomTabBarPreference? {
        get { self[CustomTabBarEnvironmentKey.self] }
        set { self[CustomTabBarEnvironmentKey.self] = newValue }
    }
}

// MARK: Preferences

struct CustomTabBarPreference: Equatable, Identifiable {
    let id: Int
    let tabView: AnyView
    
    static func == (lhs: CustomTabBarPreference, rhs: CustomTabBarPreference) -> Bool {
        lhs.id == rhs.id
    }
}

struct CustomTabBarPreferenceKey: PreferenceKey {
    static var defaultValue: [CustomTabBarPreference] = []
    
    static func reduce(value: inout [CustomTabBarPreference], nextValue: () -> [CustomTabBarPreference]) {
        value += nextValue()
    }
}
