//
//  Launches.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

public class Launches: BaseEndpoint, @unchecked Sendable {
    public override var path: String {
        super.path + "/launches"
    }
}
