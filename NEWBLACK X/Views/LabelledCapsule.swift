//
//  LabelledCapsule.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct LabelledCapsule<Image: View, Label: View>: View {

    let image: () -> Image
    let label: () -> Label

    var body: some View {
        HStack(spacing: 4) {
            image()
                .foregroundStyle(.tint)
            label()
                .font(.caption)
                .foregroundStyle(.tint)
        }
        .padding(4)
        .padding(.trailing, 4)
        .background {
            SwiftUI.Capsule()
                .fill(.tint.opacity(0.1))
        }
    }
}

extension EnvironmentValues {
    @Entry
    var labelledCapsuleTint: Color = .secondary
}
