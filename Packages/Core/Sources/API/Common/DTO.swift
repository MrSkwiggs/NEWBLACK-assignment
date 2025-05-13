//
//  DTO.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//

import Foundation

public protocol APIModel: Sendable, Decodable, Equatable, Hashable {}


/// A type that represents an API Model.
public protocol DTO: APIModel, Identifiable where Field.RawValue == String {
    /// A type that represents fields of the Model.
    associatedtype Field: RawRepresentable, Sendable, Hashable, CaseIterable, Equatable

//    typealias Filter = Query<Self>.Filter
}
