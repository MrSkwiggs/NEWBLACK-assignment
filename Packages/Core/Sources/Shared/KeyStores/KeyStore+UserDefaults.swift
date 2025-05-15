//
//  KeyStore+UserDefaults.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Foundation

public extension KeyStore {
    /// A KeyStore which persists data in Foundation's UserDefaults
    static func userDefaults(
        suitePrefix: String,
        bundleIdentifier: String? = Bundle.main.bundleIdentifier,
        encoder: JSONEncoder = .init(),
        decoder: JSONDecoder = .init()
    ) -> KeyStore {

        let suiteName = bundleIdentifier.map { "\($0).\(suitePrefix)" } ?? suitePrefix

        return .init(encoder: encoder, decoder: decoder) { key in
            UserDefaults(suiteName: suiteName)?.data(forKey: key.identifier)
        } set: { data, key in
            UserDefaults(suiteName: suiteName)?.set(data, forKey: key.identifier)
        } delete: { key in
            UserDefaults(suiteName: suiteName)?.set(Optional<Data>.none, forKey: key.identifier)
        } clear: {
            UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
        }
    }
}
