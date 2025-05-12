//
//  StickyHeaderList.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct StickyHeaderList<Header: View, Content: View>: View {

    let header: Header
    let content: Content

    @State private var offset: CGFloat = 0

    init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.content = content()
    }

    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .top) {
                List {
                    content
                }
                .safeAreaPadding(.top, 300 - reader.safeAreaInsets.top)
                .onScrollGeometryChange(for: CGFloat.self, of: { geo in
                    return geo.contentOffset.y + geo.contentInsets.top
                }, action: { new, old in
                    offset = new
                })

                header
                    .aspectRatio(contentMode: .fill)
                    .frame(width: reader.size.width, height: 300 + max(0, -offset))
                    .clipped()
                    .ignoresSafeArea(.all, edges: .top)
                    .transformEffect(.init(translationX: 0, y: -(max(0, offset + reader.safeAreaInsets.top))))
            }
        }
    }
}

#Preview {
    StickyHeaderList {
        LinearGradient(colors: [.orange, .pink, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
    } content: {
        Section {
            Text("Hello")
        }

        ForEach(0..<100) { index in
            Text("Item \(index)")
        }
    }
}
