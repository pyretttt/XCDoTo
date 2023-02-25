////
//  BlurView.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 09.02.2023.
//

import SwiftUI
import AppKit

struct BlurView: NSViewRepresentable {
    typealias NSViewType = NSVisualEffectView
    
    private let material: NSVisualEffectView.Material
    
    init(material: NSVisualEffectView.Material) {
        self.material = material
    }
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        
        view.blendingMode = .behindWindow
        
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
