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

    init(images: [URL], @ViewBuilder content: () -> Content) {
        self.images = images
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            GeometryReader { reader in
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 0) {
                        ForEach(images, id: \.self) { imageURL in
                            AsyncImage(url: imageURL) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                            } placeholder: {
                                ZStack {
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

import Mocks
import Shared
#Preview {
    StickyHeaderList {
        AsyncGallery(images: Launch.kerbalSP.imageURLs) {
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
