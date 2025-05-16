//
//  Mockable.swift
//  Core
//
//  Created by Dorian on 16/05/2025.
//

public protocol Mockable {
    static var mocks: [Self] { get }
}
