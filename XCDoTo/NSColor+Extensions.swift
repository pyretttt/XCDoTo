////
//  NSColor+Extensions.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 03.01.2023.
//

import AppKit

extension NSColor {
    static func fromHEX(_ hex: UInt32, alpha: CGFloat = 1) -> NSColor {
        let r = (hex >> 16) & 0xFF
        let g = (hex >> 8) & 0xFF
        let b = hex & 0xFF
        
        return NSColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: alpha)
    }
}
