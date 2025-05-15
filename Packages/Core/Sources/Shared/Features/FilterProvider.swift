//
//  FilterProvider.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

/// A type provides a way to store and retrieve filters for date ranges.
public protocol FilterProviding: Sendable, Actor {
    /// The filters currently in use
    var filters: [DateRangeFilter] { get set }
    /// Whether or not the filters are active
    var isActive: Bool { get set }
}

public actor FilterProvider: FilterProviding {
    private let store: KeyStore

    private let filterKey: KeyStore.Key = "dateRangeFilter"
    private let isActiveKey: KeyStore.Key = "dateRangeFilterActive"

    package init(store: KeyStore) {
        self.store = store
    }

    public var isActive: Bool {
        get {
            do {
                return try store.get(for: isActiveKey) ?? false
            } catch {
                print("Failed to get filter active state from store: \(error)")
                store.delete(key: isActiveKey)
                return false
            }
        }
        set {
            do {
                try store.set(newValue, for: isActiveKey)
            } catch {
                print("Failed to set filter active state in store: \(error)")
            }
        }
    }

    /// The filters currently in use
    public var filters: [DateRangeFilter] {
        get {
            do {
                return try store.get(for: filterKey) ?? []
            } catch {
                print("Failed to get filters from store: \(error)")
                store.delete(key: filterKey)
                return []
            }
        }
        set {
            do {
                try store.set(newValue, for: filterKey)
            } catch {
                print("Failed to set filters in store: \(error)")
            }
        }
    }
}
