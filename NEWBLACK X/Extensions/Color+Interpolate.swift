//
//  Color+Interpolate.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

extension Array where Element == Color {

    func interpolateColor(at point: CGFloat) -> Color? {
        guard !isEmpty else { return nil }
        if count == 1 {
            return first
        }

        let clampedPoint = Swift.max(0, Swift.min(1, point))

        let scaledPosition = clampedPoint * CGFloat(count - 1)
        let lowerIndex = Int(scaledPosition)

        if lowerIndex >= count - 1 {
            return self.last
        }

        let upperIndex = lowerIndex + 1
        let fraction = scaledPosition - CGFloat(lowerIndex)

        let lower = self[lowerIndex]
        let upper = self[upperIndex]

        return lower.mix(with: upper, by: fraction)
    }
}

extension Gradient {
    static let redToGreen = Gradient(colors: [Color.red, .yellow, .green])

    func interpolateColor(at point: CGFloat) -> Color? {
        let colors = self.stops.map(\.color)
        return colors.interpolateColor(at: point)
    }
}

#Preview {

    @Previewable
    @State
    var fraction: CGFloat = 0.5

    var colors: [Color] = [.red, .yellow, .blue]

    List {
        Rectangle()
            .fill(colors.interpolateColor(at: fraction)!)
            .frame(height: 300)
            .listRowInsets(.init())

        Section {
            Slider(value: $fraction, in: 0...1)
                .padding()
                .background {
                    LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                }
                .listRowInsets(.init())
                .tint(.white)
        }
    }
}
