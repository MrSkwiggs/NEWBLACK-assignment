//
//  Links.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

import Foundation
import Entities

extension Links: Mockable {
    public static let munaholic = Links(
        webcast: URL(string: "https://youtube.com/watch?v=munaholic-success"),
        wikipedia: URL(string: "https://kerbalwiki.com/Munaholic_Achievement")
    )

    public static let splashdown = Links(
        webcast: URL(string: "https://livestream.com/ksc/splashdown-whoa"),
        wikipedia: nil
    )

    public static let kraken = Links(
        webcast: URL(string: "https://twitch.tv/ksc/kraken-live"),
        wikipedia: URL(string: "https://kerbalwiki.com/Space_Kraken_Unleashed")
    )

    public static let none = Links(webcast: nil, wikipedia: nil)

    public static var mocks: [Links] {
        [
            munaholic,
            splashdown,
            kraken,
            none
        ]
    }
}
