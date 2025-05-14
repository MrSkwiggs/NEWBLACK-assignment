//
//  UnitForce.swift
//  Core
//
//  Created by Dorian on 13/05/2025.
//

import Foundation

/// A custom `Dimension` subclass to represent units of force.
/// The base unit is the **newton (N)**.
public class UnitForce: Dimension, @unchecked Sendable {

    /// The SI base unit of force.
    /// Defined as the force required to accelerate 1 kilogram by 1 meter per second squared.
    /// `1 N = 1 kg·m/s²`
    public static let newton = UnitForce(symbol: "N", converter: UnitConverterLinear(coefficient: 1))

    /// Kilonewton — commonly used in structural engineering and mechanical loads.
    /// `1 kN = 1,000 N`
    public static let kiloNewton = UnitForce(symbol: "kN", converter: UnitConverterLinear(coefficient: 1_000))

    /// Meganewton — used in heavy industries, aerospace, and large-scale engineering.
    /// `1 MN = 1,000,000 N`
    public static let megaNewton = UnitForce(symbol: "MN", converter: UnitConverterLinear(coefficient: 1_000_000))

    /// Dyne — a CGS unit (centimeter-gram-second system).
    /// Often used in theoretical physics or legacy scientific literature.
    /// `1 dyn = 1e-5 N`
    public static let dyne = UnitForce(symbol: "dyn", converter: UnitConverterLinear(coefficient: 1e-5))

    /// Kilogram-force (kgf) — the force exerted by Earth's gravity on a 1 kg mass.
    /// Common in older engineering systems and weight-based force measurements.
    /// `1 kgf = 9.80665 N`
    public static let kilogramForce = UnitForce(symbol: "kgf", converter: UnitConverterLinear(coefficient: 9.80665))

    /// Gram-force (gf) — small-scale gravitational force unit.
    /// `1 gf = 0.00980665 N`
    public static let gramForce = UnitForce(symbol: "gf", converter: UnitConverterLinear(coefficient: 0.00980665))

    /// Metric ton-force (tf) — force of gravity on a mass of one metric ton.
    /// `1 tf = 9806.65 N`
    public static let tonForce = UnitForce(symbol: "tf", converter: UnitConverterLinear(coefficient: 9806.65))

    /// Pound-force (lbf) — standard unit of force in the imperial (US customary) system.
    /// Defined as the force of gravity on a mass of one pound.
    /// `1 lbf = 4.44822 N`
    public static let poundForce = UnitForce(symbol: "lbf", converter: UnitConverterLinear(coefficient: 4.44822))

    /// Ounce-force (ozf) — used for smaller-scale force in imperial systems.
    /// `1 ozf = 0.2780139 N`
    public static let ounceForce = UnitForce(symbol: "ozf", converter: UnitConverterLinear(coefficient: 0.2780139))

    public override class func baseUnit() -> Self {
        return Self.newton as! Self
    }
}
