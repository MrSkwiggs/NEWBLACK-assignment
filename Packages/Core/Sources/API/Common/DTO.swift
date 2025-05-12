//
//  DTO.swift
//  Core
//
//  Created by Dorian on 11/05/2025.
//


/// A type that represents an API Model.
public protocol DTO: Decodable, Sendable, Identifiable, Equatable where Field.RawValue == String {
    /// A type that represents fields of the Model.
    associatedtype Field: RawRepresentable, Sendable, Hashable, CaseIterable, Equatable

//    typealias Filter = Query<Self>.Filter
}
