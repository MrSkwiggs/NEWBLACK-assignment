//
//  ShakeEffect.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import SwiftUI

struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit: CGFloat = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * shakesPerUnit), y: 0))
    }
}

extension View {
    /// Applies a shake effect to the view.
    func shakeEffect(activate: Bool, amount: CGFloat = 8, shakesPerUnit: CGFloat = 3) -> some View {
        self.modifier(ShakeEffect(amount: amount, shakesPerUnit: shakesPerUnit, animatableData: activate ? 1 : 0))
    }
}
