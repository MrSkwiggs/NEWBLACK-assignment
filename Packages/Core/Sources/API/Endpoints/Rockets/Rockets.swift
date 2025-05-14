//
//  Rockets.swift
//  Core
//
//  Created by Dorian on 14/05/2025.
//

public class Rockets: BaseEndpoint, @unchecked Sendable {
    public override var path: String {
        super.path + "/rockets"
    }
}

public extension API {
    enum Rockets {}
}
