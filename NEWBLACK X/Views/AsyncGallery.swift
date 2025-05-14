//
//  AsyncGallery.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct AsyncGallery<Content: View>: View {

    let images: [URL]
    let content: Content

    init(images: [URL], @ViewBuilder content: () -> Content = { EmptyView() }) {
        self.images = images
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { reader in
                if images.isEmpty {
                    ZStack {
                        Rectangle()
                            .fill(.tertiary)
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.quaternary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 0) {
                            ForEach(images, id: \.self) { imageURL in
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .clipped()
                                } placeholder: {
                                    ZStack(alignment: .center) {
                                        Rectangle()
                                            .fill(.tertiary)
                                        ProgressView()
                                    }
                                }
                                .frame(width: reader.size.width, height: reader.size.height)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .scrollTargetBehavior(.viewAligned)
                }
            }
            .overlay {
                VStack(alignment: .leading) {
                    Spacer()
                    content
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background {
                    LinearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .black
                    ], startPoint: .top, endPoint: .bottom)
                }
                .allowsHitTesting(false)
            }
        }
    }
}

import Mocks
import API

#Preview("With Image") {
    StickyHeaderList {
        AsyncGallery(images: Rocket.kraken.imageURLs) {
            Text("Hello")
                .padding()
                .bold()
                .foregroundStyle(.white)
        }
    } content: {
        ForEach(0..<100) { index in
            Text("Item \(index)")
        }
    }
}

#Preview("Loading Image") {
    StickyHeaderList {
        AsyncGallery(images: [.temporaryDirectory]) {
            Text("Hello")
                .padding()
                .bold()
                .foregroundStyle(.white)
        }
    } content: {
        ForEach(0..<100) { index in
            Text("Item \(index)")
        }
    }
}

#Preview("Without Image") {
    StickyHeaderList {
        AsyncGallery(images: []) {
            Text("Hello")
                .padding()
                .bold()
                .foregroundStyle(.white)
        }
    } content: {
        ForEach(0..<100) { index in
            Text("Item \(index)")
        }
    }
}
