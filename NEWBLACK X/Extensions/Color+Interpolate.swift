//
//  Color+Interpolate.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

extension Array where Element == Color {

    func interpolateColor(at point: CGFloat) -> Color? {
        let colors = self.map { UIColor($0) }
        guard !colors.isEmpty else { return nil }
        if colors.count == 1 {
            return first
        }

        let clampedPoint = Swift.max(0, Swift.min(1, point))

        let scaledPosition = clampedPoint * CGFloat(colors.count - 1)
        let lowerIndex = Int(scaledPosition)

        if lowerIndex >= colors.count - 1 {
            return self.last
        }

        let upperIndex = lowerIndex + 1
        let fraction = scaledPosition - CGFloat(lowerIndex)

        guard let lowerComponents = getRGBAComponents(from: colors[lowerIndex]),
              let upperComponents = getRGBAComponents(from: colors[upperIndex]) else {
            return nil
        }

        let red = lowerComponents.red + (upperComponents.red - lowerComponents.red) * fraction
        let green = lowerComponents.green + (upperComponents.green - lowerComponents.green) * fraction
        let blue = lowerComponents.blue + (upperComponents.blue - lowerComponents.blue) * fraction
        let alpha = lowerComponents.alpha + (upperComponents.alpha - lowerComponents.alpha) * fraction

        return Color(UIColor(red: red, green: green, blue: blue, alpha: alpha))
    }

    private func getRGBAComponents(from color: UIColor) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if color.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        } else {
            guard let cgColor = color.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil),
                  let components = cgColor.components, components.count >= 3 else {
                return nil
            }
            let alpha = cgColor.alpha
            if components.count == 4 {
                return (components[0], components[1], components[2], alpha)
            } else {
                return (components[0], components[0], components[0], alpha)
            }
        }
    }
}
