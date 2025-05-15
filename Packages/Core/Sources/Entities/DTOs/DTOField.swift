//
//  DTOField.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

import Foundation

/// A type that represents a field in a Data Transfer Object (DTO).
public protocol DTOField: RawRepresentable, Sendable, Hashable, CaseIterable, Equatable {}
