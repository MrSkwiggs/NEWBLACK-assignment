//
//  KeyStoreTests.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Testing
import Foundation
@testable import Shared
import Mocks

@Suite("KeyStore Tests")
final class KeyStoreTests: Sendable {

    let encoder: JSONEncoder = .init()
    let decoder: JSONDecoder = .init()

    let expectedKey: KeyStore.Key = "testKey"

    @Test func keyStoreSetsData() async throws {

        let expectedValue: String = UUID().uuidString
        let expectedData = try encoder.encode(expectedValue)
        try await confirmation { setData in

            let keyStore = KeyStore.mock(encoder: encoder, set: { data, key in
                setData()
                #expect(data == expectedData)
                #expect(key == self.expectedKey)
            })

            try keyStore.set(expectedValue, for: expectedKey)
        }
    }

    @Test func keyStoreGetsData() async throws {
        let expectedValue: String = UUID().uuidString
        let expectedData = try encoder.encode(expectedValue)
        try await confirmation { getsData in
            let keyStore = KeyStore.mock(encoder: encoder, get: { key in
                getsData()
                #expect(key == self.expectedKey)
                return expectedData
            })

            let value: String? = try keyStore.get(for: expectedKey)

            #expect(value == expectedValue)
        }
    }

    @Test func keyStoreRemovesData() async throws {
        try await confirmation(expectedCount: 2) { removesData in
            let keyStore = KeyStore.mock(encoder: encoder, delete: { key in
                removesData()
                #expect(key == self.expectedKey)
            })

            keyStore.delete(key: expectedKey)
            try keyStore.set(Optional<String>.none, for: expectedKey)
        }
    }

    @Test func keyStoreRemovesAllData() async throws {
        await confirmation { removesAllData in
            let keyStore = KeyStore.mock(encoder: encoder, clear: {
                removesAllData()
            })

            keyStore.clear()
        }
    }
}
