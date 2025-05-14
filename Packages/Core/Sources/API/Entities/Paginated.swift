//
//  Paginated.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public struct Paginated<Item: Sendable & Decodable>: Sendable, Decodable {
    public let docs: [Item]
    public let page: Int
    public let pageSize: Int

    enum CodingKeys: String, CodingKey {
        case docs
        case page
        case pageSize = "limit"
    }
}
