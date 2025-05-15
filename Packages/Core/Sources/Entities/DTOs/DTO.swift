//
//  DTO.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//

import Foundation

/// A type that represents an API DTO.
public protocol DTO: APIModel, Identifiable where Field.RawValue == String, Field.AllCases == [Field] {
    /// A type that represents fields of the Model.
    associatedtype Field: DTOField
}
