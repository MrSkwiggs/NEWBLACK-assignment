//
//  DTO.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//

import Foundation

public protocol APIModel: Sendable, Decodable, Equatable, Hashable {}


/// A type that represents an API Model.
public protocol DTO: APIModel, Identifiable where Field.RawValue == String, Field.AllCases == [Field] {
    /// A type that represents fields of the Model.
    associatedtype Field: DTOField

    typealias Filter = Query<Self>.Filter
    typealias Option = Query<Self>.Option
}

public protocol DTOField: RawRepresentable, Sendable, Hashable, CaseIterable, Equatable {}
