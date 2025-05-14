//
//  Launches.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

/// Base Launches endpoint.
public class Launches: BaseEndpoint, @unchecked Sendable {
    public override var path: String {
        super.path + "/launches"
    }
}

public extension API {
    enum Launches {}
}
