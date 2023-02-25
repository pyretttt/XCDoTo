////
//  LabelContent.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 10.02.2023.
//

import SwiftUI

struct LabelContent<Content: View>: View {
    
    private let label: String
    private let content: () -> Content
    
    init(label: String, _ content: @escaping () -> Content) {
        self.label = label
        self.content = content
    }
    
    var body: some View {
        HStack(spacing: 6) {
            Text(label)
                .font(.system(size: 10, weight: .regular))
            content()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
