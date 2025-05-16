//
//  ViewIdentifiers.swift
//  Core
//
//  Created by Dorian on 16/05/2025.
//

/// A base class for view identifiers.
public final class ViewIdentifiers: Sendable {
    /// The ID class of a view.
    open class ID: BaseViewIdentifiers {
        public init(file: String) {
            super.init(bundleIdentifier: "PinchAssignment", file: file)
        }

        public func id(_ id: String) -> String {
            "\(key)_\(id)"
        }
    }

    /// The Main view identifiers.
    public static let main: ViewIdentifiers = .init()
}

#if canImport(SwiftUI)
import SwiftUI

public extension View {
    /// Assigns the root accessibility identifier to this view
    func rootIdentifier<Base: BaseViewIdentifiers>(_ identifer: KeyPath<ViewIdentifiers, Base>) -> some View {
        self
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier(ViewIdentifiers.main[keyPath: identifer].root)
    }

    /// Assigns the given accessibility identifier to this subview
    func elementIdentifier(_ identifier: KeyPath<ViewIdentifiers, String>) -> some View {
        self.accessibilityIdentifier(ViewIdentifiers.main[keyPath: identifier])
    }
}
#endif
