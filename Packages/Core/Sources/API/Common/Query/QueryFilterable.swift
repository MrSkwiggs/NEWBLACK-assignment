//
//  QueryFilterable.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A type that can be used for query filtering.
public protocol QueryFilterable: Sendable, Equatable, Codable {}

extension String: QueryFilterable {}
extension Int: QueryFilterable {}
extension Double: QueryFilterable {}
extension Date: QueryFilterable {}
extension Bool: QueryFilterable {}
