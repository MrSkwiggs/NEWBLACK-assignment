//
//  KeyStore+Ephemeral.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//


import Foundation

public extension KeyStore {
    /// A KeyStore whose storage is kept in memory and therefore only lasts until the app is restarted
    static func ephemeral(_ values: [String: any Codable] = [:], encoder: JSONEncoder = .init(), decoder: JSONDecoder = .init()) -> KeyStore {

        var dataValues = values.reduce(into: [String: Data]()) { result, keyVal in
            result[keyVal.key] = try! encoder.encode(keyVal.value)
        }

        return .init(
            get: { key in
                dataValues[key.identifier]
            }, set: { data, key in
                dataValues[key.identifier] = data
            }, delete: { key in
                dataValues.removeValue(forKey: key.identifier)
            }, clear: {
                dataValues = [:]
            },
            encoder: encoder,
            decoder: decoder
        )
    }
}
