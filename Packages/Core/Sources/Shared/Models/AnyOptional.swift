//
//  AnyOptional.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

protocol AnyOptional {
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    var isNil: Bool { self == nil }
}
