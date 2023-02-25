////
//  View+Styles.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 20.02.2023.
//

import SwiftUI

extension Color {
    static let textEditorColor: Color = Color(nsColor: .fromHEX(0x2C2931))
    static let accentBlue: Color = Color(nsColor: .fromHEX(0x356BC0).withAlphaComponent(0.7))
}

extension Divider {
    static func appStyled(alpha: CGFloat = 0.5) -> some View {
        Divider()
            .background(Color(.fromHEX(0xF1F1F1).withAlphaComponent(alpha)))
    }
}
