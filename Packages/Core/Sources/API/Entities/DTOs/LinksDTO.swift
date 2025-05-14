//
//  LinksDTO.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

public struct LinksDTO: APIModel {
    public let webcast: URL?
    public let wikipedia: URL?

    public init(
        webcast: URL,
        wikipedia: URL
    ) {
        self.webcast = webcast
        self.wikipedia = wikipedia
    }
}
