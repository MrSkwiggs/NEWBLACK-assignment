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

    typealias Filter = Query<Launch>.Filter
    typealias Option = Query<Launch>.Option

    let encoder: JSONEncoder = {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        encoder.dateEncodingStrategy = .secondsSince1970
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


    private static let startDate = Date(timeIntervalSince1970: 12345)
    private static let endDate = Date(timeIntervalSince1970: 67890)
    @Test(
        "Compound Filters",
        arguments: zip(
            [
                Filter.range(field: .id, range: 0..<10),
                Filter.range(field: .id, range: 0...10),
                Filter.range(field: .date, range: startDate..<endDate),
                Filter.range(field: .date, range: startDate...endDate),
            ],
            [
                #"{"id":{"$gte":0,"$lt":10}}"#,
                #"{"id":{"$gte":0,"$lte":10}}"#,
                #"{"date_unix":{"$gte":12345,"$lt":67890}}"#,
                #"{"date_unix":{"$gte":12345,"$lte":67890}}"#
            ]
        )
    )
    func testCompoundFilterEncoding(filter: Filter, expectedResult: String) async throws {
        let data = try encoder.encode(filter)

        guard let string = String(data: data, encoding: .utf8) else {
            Issue.record("Failed to convert data to string")
            return
        }

        #expect(string == expectedResult)
    }

    @Test(
        "Options",
        arguments: zip(
            [
                Option.select(fields: [.id, .name]),
                Option.populate(fields: [.launchpad, .rocketID]),
                Option.pagination(.init(page: 3, pageSize: 20)),
                Option.sort([.by(.id, .forward), .by(.name, .reverse)]),
            ],
            [
                #"{"select":["id","name"]}"#,
                #"{"populate":["launchpad","rocket"]}"#,
                #"{"limit":20,"page":3}"#,
                #"{"sort":[["id","asc"],["name","desc"]]}"#
            ]
        )
    )
    func testOptionEncoding(option: Option, expectedResult: String) async throws {
        let data = try encoder.encode(TestStruct(option: option))

        guard let string = String(data: data, encoding: .utf8) else {
            Issue.record("Failed to convert data to string")
            return
        }

        #expect(string == expectedResult)
    }

    private struct TestStruct: Encodable {
        let option: Option

        func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: DynamicCodingKey.self)
            try option.encode(to: &container)
        }
    }

    @Test(
        "Complete Query",
        arguments: zip(
            [
                Query<Launch>(
                    filter: .equals(field: .details, value: "some details"),
                    options: [
                        .populate(fields: [.details])
                    ]
                ),
                Query<Launch>(
                    filter: .empty,
                    options: []
                ),
                Query<Launch>(
                    filter: .empty,
                    options: [
                        .sort([.by(.id, .forward), .by(.name, .reverse)]),
                    ]
                ),
            ],
            [
                #"{"options":{"populate":["details"]},"query":{"details":"some details"}}"#,
                #"{"options":{},"query":{}}"#,
                #"{"options":{"sort":[["id","asc"],["name","desc"]]},"query":{}}"#
            ]
        )
    )
    func testCompleteQueryEncoding(query: Query<Launch>, expectedResult: String) async throws {
        let data = try encoder.encode(query)

        guard let string = String(data: data, encoding: .utf8) else {
            Issue.record("Failed to convert data to string")
            return
        }

        #expect(string == expectedResult)
    }
}
