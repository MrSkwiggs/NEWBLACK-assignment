//
//  ViewIdentifiersProviding.swift
//  Core
//
//  Created by Dorian on 16/05/2025.
//

import Foundation

/// A view identifier
public protocol ViewIdentifiersProviding {

    /// The identifier of the bundle containing this view
    var bundleIdentifier: String { get }

    /// The filename or name of this view
    var file: String { get }

    /// The view's key identifier, to use as a prefix for its content
    var key: String { get }

    /// The identifier associated with this view's root content (the view itself)
    var root: String { get }
}

/// A base implementation of the ViewIdentifiersProviding protocol
open class BaseViewIdentifiers: ViewIdentifiersProviding {
    public let bundleIdentifier: String
    public let file: String
    public let key: String
    public let root: String

    private static func fileName(from file: String) -> String {
        guard let file = file.split(whereSeparator: { $0 == "/" }).last?.split(whereSeparator: { $0 == "." }).first else {
            fatalError("Invalid file name")
        }
        return String(file)
    }

    internal init(bundle: Bundle, file: String = #file) {
        guard let bundleIdentifier = bundle.bundleIdentifier else {
            fatalError("Missing Bundle Identifier")
        }
        let file = Self.fileName(from: file)
        let key = "\(bundleIdentifier)_\(file)"
        let root = "\(key)_root"

        self.bundleIdentifier = bundleIdentifier
        self.file = file
        self.key = key
        self.root = root
    }

    internal init(bundle: Bundle, file: String = #file, key: String? = nil, root: String? = nil) {
        guard let bundleIdentifier = bundle.bundleIdentifier else { fatalError("Missing Bundle Identifier") }
        let file = Self.fileName(from: file)
        let key = key ?? "\(bundleIdentifier)_\(file)"
        let root = root ?? "\(key)_root"
        
        self.bundleIdentifier = bundleIdentifier
        self.file = file
        self.key = key
        self.root = root
    }

    internal init(bundleIdentifier: String, file: String, key: String? = nil, root: String? = nil) {
        let key = key ?? "\(bundleIdentifier)_\(file)"
        let root = root ?? "\(key)_root"

        self.bundleIdentifier = bundleIdentifier
        self.file = file
        self.key = key
        self.root = root
    }
}

#if canImport(SwiftUI)
import SwiftUI

public extension View {
    /// Assigns the root accessibility identifier to this view
    func rootIdentifier<Base: BaseViewIdentifiers>(_ identifer: Base) -> some View {
        self
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier(identifer.root)
    }

    /// Assigns the given accessibility identifier to this subview
    func elementIdentifier(_ identifier: String) -> some View {
        self.accessibilityIdentifier(identifier)
    }
}
#endif
