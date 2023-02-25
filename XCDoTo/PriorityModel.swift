////
//  Priority.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 03.01.2023.
//

import Foundation

enum PriorityModel: String, Hashable, CaseIterable, Codable {
    case low
    case normal
    case high
    case urgent
}
