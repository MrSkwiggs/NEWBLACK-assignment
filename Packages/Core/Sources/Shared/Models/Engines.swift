//
//  Engines.swift
//  Core
//
//  Created by Dorian on 12/05/2025.
//

import Foundation
import SwiftData

@Model
public final class Engines {
    public private(set) var count: Int
    public private(set) var type: String

    package init(count: Int, type: String) {
        self.count = count
        self.type = type
    }
}
