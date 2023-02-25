////
//  View+CornerBorder.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 14.02.2023.
//

import SwiftUI

extension View {
    func cornerBorder(_ radius: CGFloat, color: Color, width: CGFloat = 1) -> some View {
        self.overlay(
            RoundedRectangle(cornerRadius: radius)
                .stroke(color, lineWidth: width)
        )
    }
}
