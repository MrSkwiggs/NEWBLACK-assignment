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

    @State
    private var offset: CGFloat = 0

    @State
    private var scaleEffect: CGFloat = 1

    init(
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.header = header()
        self.content = content()
    }

    var body: some View {
        GeometryReader { reader in
                List {
                    Section {
                    } header: {
                        header
                            .listRowInsets(.init(top: -20, leading: 0, bottom: 0, trailing: 0))
                            .frame(width: reader.size.width, height: 320)
                            .scaleEffect(x: scaleEffect, y: scaleEffect, anchor: .bottom)
                    }
                    content
                }
                .onScrollGeometryChange(for: CGFloat.self, of: { geo in
                    return geo.contentOffset.y + geo.contentInsets.top
                }, action: { new, old in
                    offset = new
                })
                .ignoresSafeArea(.all, edges: .top)
                .onChange(of: offset) {
                    scaleEffect = max(1, 1 + (-offset / reader.size.height * (reader.size.height / 300)))
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
