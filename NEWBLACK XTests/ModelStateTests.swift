//
//  ModelStateTests.swift
//  NEWBLACK XTests
//
//  Created by Dorian on 16/05/2025.
//

import Testing
import Entities
@testable import NEWBLACK_X
import Mocks

@Suite("Model State Tests")
struct ModelStateTests {

    @Test("Set Loading State From Existing Loaded State")
    func testSetsLoadingStateFromExisting() async throws {
        let expectedItems = [Launch.minmusMambo]
        var state = ModelState<Launch>.loaded(items: expectedItems)

        state.setLoading()

        switch state {
        case .loading(let previousItems):
            #expect(previousItems == expectedItems)
        case .loaded(let items):
            Issue.record("Expected loading state, got loaded with items: \(items)")
        case .noContent:
            Issue.record("Expected loading state, got no content")
        case .error:
            Issue.record("Expected loading state, got error")
        }
    }

    @Test("Set Loading State From Empty Loaded State")
    func testSetsLoadingStateFromEmpty() async throws {
        let expectedItems = Launch.mocks
        var state = ModelState<Launch>.loaded(items: [])

        state.setLoading()

        switch state {
        case .loading(let previousItems):
            #expect(previousItems == expectedItems)
        case .loaded(let items):
            Issue.record("Expected loading state, got loaded with items: \(items)")
        case .noContent:
            Issue.record("Expected loading state, got no content")
        case .error:
            Issue.record("Expected loading state, got error")
        }
    }

    @Test("Append Items", arguments: zip(
        [
            ModelState<Launch>.loading(previousItems: []),
            .loading(previousItems: [.krakenUnleashed]),
            .loaded(items: []),
            .loaded(items: [.krakenUnleashed]),
        ],
        [
            [Launch.minmusMambo],
            [.minmusMambo],
            [.minmusMambo],
            [.krakenUnleashed, .minmusMambo]
        ])
    )
    func testAppendItems(state: ModelState<Launch>, expectedItems: [Launch]) async throws {
        var state = state

        state.add(items: [.minmusMambo])

        switch state {
        case .loading(let previousItems):
            Issue.record("Expected loaded state, got loading with previous items: \(previousItems)")
        case .loaded(let items):
            #expect(items == expectedItems)
        case .noContent:
            Issue.record("Expected loading state, got no content")
        case .error:
            Issue.record("Expected loading state, got error")
        }
    }
}
