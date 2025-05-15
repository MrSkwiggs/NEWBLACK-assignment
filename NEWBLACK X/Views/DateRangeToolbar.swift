//
//  DateRangeToolbar.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct DateRangeToolbar: ToolbarContent {

    let isFilterActive: Bool

    @Binding
    var showDateRangeFilter: Bool

    let disableFilter: () -> Void

    var body: some ToolbarContent {
        if isFilterActive {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    disableFilter()
                }) {
                    Text("Clear")
                }
            }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showDateRangeFilter.toggle()
            }) {
                Image(systemName:
                        isFilterActive
                      ? "line.3.horizontal.decrease.circle.fill"
                      : "line.3.horizontal.decrease.circle"
                )
            }
            .navigationTitle(
                isFilterActive
                ? "Filtered by date"
                : ""
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {

    @Previewable
    @State
    var isActive: Bool = false

    NavigationStack {
        Text("Hello, World!")
            .toolbar {
                DateRangeToolbar(
                    isFilterActive: isActive,
                    showDateRangeFilter: .constant(false)
                ) {}
            }
    }
}
