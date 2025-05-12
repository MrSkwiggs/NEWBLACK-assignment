//
//  URLQueryItem+Convenience.swift
//  Networking
//

import Foundation

extension URLQueryItem {
    static func page(_ page: Int) -> Self {
        .init(name: "page", value: "\(page)")
    }

    static func perPage(_ count: Int) -> Self {
        .init(name: "perPage", value: "\(count)")
    }
}
