//
//  StickyHeaderList.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct StickyHeaderList<Header: View, Content: View>: View {

    @Environment(\.stickyHeaderListStyle)
    var style: StickyHeaderListStyle

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

    private let scalePadding: CGFloat = 20

    var body: some View {
        GeometryReader { reader in
            List {
                Section {
                } header: {
                    header
                        .listRowInsets(.init(top: -20, leading: 0, bottom: 0, trailing: 0))
                        .frame(width: reader.size.width, height: style.headerHeight + scalePadding)
                        .scaleEffect(x: scaleEffect, y: scaleEffect, anchor: .bottom)
                        .textCase(nil)
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
                scaleEffect = max(1, 1 + (-offset / reader.size.height * (reader.size.height / style.headerHeight)))
            }
        }
    }
}

enum StickyHeaderListStyle {
    case large
    case medium
    case small

    var headerHeight: CGFloat {
        switch self {
        case .large:
            450
        case .medium:
            300
        case .small:
            200
        }
    }
}

extension EnvironmentValues {
    @Entry
    var stickyHeaderListStyle: StickyHeaderListStyle = .large
}

extension View {
    func stickyHeaderListStyle(_ style: StickyHeaderListStyle) -> some View {
        environment(\.stickyHeaderListStyle, style)
    }
}

#Preview("Large") {
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

#Preview("Medium") {
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
    .stickyHeaderListStyle(.medium)
}

#Preview("Small") {
    Text("Hello")
        .sheet(isPresented: .constant(true)) {
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
            .stickyHeaderListStyle(.small)
        }
}
