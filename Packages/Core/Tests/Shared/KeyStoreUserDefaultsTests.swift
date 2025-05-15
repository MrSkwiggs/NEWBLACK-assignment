//
//  KeyStoreUserDefaultsTests.swift
//  Core
//
//  Created by Dorian on 15/05/2025.
//

import Testing
import Foundation
@testable import Shared

@Suite("KeyStore UserDefaults Tests")
struct KeyStoreUserDefaultsTests {

    let suitePrefix: String = "KeyStoreUserDefaultsTests"
    let defaults: UserDefaults
    let encoder: JSONEncoder = JSONEncoder()
    let decoder: JSONDecoder = JSONDecoder()

    let keyStore: KeyStore

    let expectedKey: KeyStore.Key = "testKey"

    struct TestValue1: Codable, Equatable {
        let value: String
        static let key: KeyStore.Key = "testKey1"
    }

    struct TestValue2: Codable, Equatable {
        let value: String
        static let key: KeyStore.Key = "testKey2"
    }

    struct TestValue3: Codable, Equatable {
        let value: String
        static let key: KeyStore.Key = "testKey3"
    }

    init() {
        defaults = UserDefaults(suiteName: suitePrefix)!
        defaults.removePersistentDomain(forName: suitePrefix)
        keyStore = KeyStore.userDefaults(suitePrefix: suitePrefix, bundleIdentifier: nil, encoder: encoder, decoder: decoder)
        keyStore.clear()
    }

    @Test func defaultsReceiveData() async throws {
        let expectedValue = "testValue"
        let expectedData = try encoder.encode(expectedValue)
        withKnownIssue {
            try keyStore.set(expectedValue, for: expectedKey)

            #expect(try keyStore.get(for: expectedKey) == expectedValue)

            guard let actualData = defaults.data(forKey: expectedKey.identifier) else {
                Issue.record("Failed to retrieve data from UserDefaults")
                return
            }

            #expect(actualData == expectedData)

            let actualValue: String = try decoder.decode(String.self, from: actualData)

            #expect(actualValue == expectedValue)
        }
    }

    @Test func defaultsDeleteData() async throws {
        let expectedValue = "testValue"
        let expectedData = try encoder.encode(expectedValue)

        withKnownIssue {
            try keyStore.set(expectedValue, for: expectedKey)

            #expect(try keyStore.get(for: expectedKey) == expectedValue)

            guard let actualData = defaults.data(forKey: expectedKey.identifier) else {
                Issue.record("Failed to retrieve data from UserDefaults")
                return
            }

            #expect(actualData == expectedData)

            keyStore.delete(key: expectedKey)
            let actualValue: String? = try keyStore.get(for: expectedKey)

            #expect(actualValue == nil)

            guard defaults.data(forKey: expectedKey.identifier) == nil else {
                Issue.record("Failed to delete data from UserDefaults")
                return
            }
        }
    }

    @Test func defaultsClearData() async throws {
        let value1 = TestValue1(value: "testValue1")
        let value2 = TestValue2(value: "testValue2")
        let value3 = TestValue3(value: "testValue3")

        try keyStore.set(value1, for: TestValue1.key)
        try keyStore.set(value2, for: TestValue2.key)
        try keyStore.set(value3, for: TestValue3.key)

        withKnownIssue {
            #expect(defaults.data(forKey: TestValue1.key.identifier) != nil)
            #expect(defaults.data(forKey: TestValue2.key.identifier) != nil)
            #expect(defaults.data(forKey: TestValue3.key.identifier) != nil)

            keyStore.clear()

            #expect(defaults.data(forKey: TestValue1.key.identifier) == nil)
            #expect(defaults.data(forKey: TestValue2.key.identifier) == nil)
            #expect(defaults.data(forKey: TestValue3.key.identifier) == nil)
        }
    }
}
