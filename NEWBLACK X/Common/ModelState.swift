//
//  ModelState.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import Foundation
import Entities
import Mocks

enum ModelState<Item: Mockable> {

    case loading(previousItems: [Item])
    case loaded(items: [Item])
    case noContent
    case error

    mutating func add(items: [Item]) {
        if case let .loaded(previousItems) = self {
            set(items: previousItems + items)
        } else {
            set(items: items)
        }
    }

    private mutating func set(items: [Item]) {
        guard !items.isEmpty else {
            self = .noContent
            return
        }
        self = .loaded(items: items)
    }

    mutating func setLoading() {
        let mocks = Item.mocks
        switch self {
        case .loading(previousItems: _):
            break
        case .loaded(let items):
            let items = items.isEmpty ? mocks : items
            self = .loading(previousItems: items)
        case .noContent:
            self = .loading(previousItems: mocks)
        case .error:
            self = .loading(previousItems: mocks)
        }
    }
}
