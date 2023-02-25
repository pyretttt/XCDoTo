////
//  XCDoTOError.swift
//  InterstateExits
//
//  Created by Semen Bakulin on 16.02.2023.
//

import Foundation

enum XCDoTOError: Error {
    case parsingError(Any.Type)
    case fileReadingError(filePath: String)
}
