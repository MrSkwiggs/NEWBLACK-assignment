//
//  QueryTests.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation
import Testing
@testable import API

@Suite("Query Tests")
struct QueryTests {

    typealias Filter = Query<LaunchDTO>.Filter
    typealias Option = Query<LaunchDTO>.Option

    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .prettyPrinted
        return encoder
    }()

    @Test(
        "Simple Filters",
        arguments: zip(
            [
                Filter.equals(field: .id, value: "123"),
                Filter.contains(field: .id, values: ["123", "456", 789]),
                Filter.greaterThan(field: .id, value: 123, inclusive: false),
                Filter.greaterThan(field: .id, value: 123, inclusive: true),
                Filter.lessThan(field: .id, value: 123, inclusive: false),
                Filter.lessThan(field: .id, value: 123, inclusive: true),
            ],
            [
                #"{"id":"123"}"#,
                #"{"id":{"$in":["123","456",789]}}"#,
                #"{"id":{"$gt":123}}"#,
                #"{"id":{"$gte":123}}"#,
                #"{"id":{"$lt":123}}"#,
                #"{"id":{"$lte":123}}"#
            ]
        )
    )
    func testSimpleFilterEncoding(filter: Filter, expectedResult: String) async throws {
        let data = try encoder.encode(filter)

        guard let string = String(data: data, encoding: .utf8) else {
            Issue.record("Failed to convert data to string")
            return
        }

        #expect(string == expectedResult)
    }

    @Test(
        "Complex Filters",
        arguments: zip(
            [
                Filter.and([
                    .equals(field: .id, value: "123"),
                    .contains(field: .id, values: ["123", "456", 789])
                ]),
                Filter.or([
                    .equals(field: .id, value: "123"),
                    .contains(field: .id, values: ["123", "456", 789])
                ]),
                Filter.and([
                    .or([
                        .equals(field: .name, value: "123"),
                        .lessThan(field: .id, value: 234, inclusive: true)
                    ]),
                    .or([
                        .equals(field: .id, value: "123"),
                        .greaterThan(field: .id, value: 456, inclusive: false)
                    ])
                ]),
            ],
            [
                #"{"$and":[{"id":"123"},{"id":{"$in":["123","456",789]}}]}"#,
                #"{"$or":[{"id":"123"},{"id":{"$in":["123","456",789]}}]}"#,
                #"{"$and":[{"$or":[{"name":"123"},{"id":{"$lte":234}}]},{"$or":[{"id":"123"},{"id":{"$gt":456}}]}]}"#
            ]
        )
    )
    func testComplexFilterEncoding(filter: Filter, expectedResult: String) async throws {
        let data = try encoder.encode(filter)

        guard let string = String(data: data, encoding: .utf8) else {
            Issue.record("Failed to convert data to string")
            return
        }

        #expect(string == expectedResult)
    }
}
