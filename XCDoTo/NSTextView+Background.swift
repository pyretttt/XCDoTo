////
//  NSTextView+Background.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 20.02.2023.
//

import AppKit

extension NSTextView {
    open override var frame: CGRect {
        didSet {
            backgroundColor = .clear
        }
    }
}
