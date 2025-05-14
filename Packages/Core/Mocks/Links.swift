//
//  Links.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

import Foundation
import API

public extension Links {
    static let munaholic = Links(
        webcast: URL(string: "https://youtube.com/watch?v=munaholic-success"),
        wikipedia: URL(string: "https://kerbalwiki.com/Munaholic_Achievement")
    )

    static let splashdown = Links(
        webcast: URL(string: "https://livestream.com/ksc/splashdown-whoa"),
        wikipedia: nil
    )

    static let kraken = Links(
        webcast: URL(string: "https://twitch.tv/ksc/kraken-live"),
        wikipedia: URL(string: "https://kerbalwiki.com/Space_Kraken_Unleashed")
    )

    static let none = Links(webcast: nil, wikipedia: nil)
}
