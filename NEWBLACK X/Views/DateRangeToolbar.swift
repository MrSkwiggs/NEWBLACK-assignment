//
//  DateRangeToolbar.swift
//  NEWBLACK X
//
//  Created by Dorian on 12/05/2025.
//

import SwiftUI

struct DateRangeToolbar: ToolbarContent {

    @State
    private var showDatePicker = false

    @Binding
    var isActive: Bool

    @Binding
    var filters: [Filter]

    @State
    var startDate: Date = .now

    @State
    var endDate: Date = .now

    let onCommit: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showDatePicker.toggle()
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
            }
            .popover(isPresented: $showDatePicker) {
                datePicker
                    .presentationDetents([.medium, .large])
                    .onDisappear {
                        onCommit()
                    }
            }
        }
    }

    private var datePicker: some View {
        List {
            Toggle(isOn: $isActive) {
                Text("Enable Filter")
            }
            Section("Select Date Range") {
                DatePicker("Start", selection: $startDate, displayedComponents: [.date])

                DatePicker("End", selection: $endDate, displayedComponents: [.date])

                Button("Add Date Range") {
                    withAnimation {
                        let range = startDate..<endDate
                        filters.append(.init(range: range))
                        isActive = true
                        startDate = .now
                        endDate = .now
                    }
                }
            }

            Section {
                if filters.isEmpty {
                    Text("No date ranges - Create one to filter launches.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(filters) { filter in
                        HStack {
                            Text(filter.range.lowerBound.formatted(date: .numeric, time: .omitted))
                            Text(" - ")
                                .foregroundStyle(.secondary)
                            Text(filter.range.upperBound.formatted(date: .numeric, time: .omitted))
                        }
                    }
                    .onDelete { index in
                        filters.remove(atOffsets: index)
                    }
                }
            } header: {
                HStack {
                    Text("Date Ranges")
                    Spacer()
                    Button("Clear all") {
                        withAnimation {
                            filters.removeAll()
                        }
                    }
                    .textCase(nil)
                    .font(.callout)
                }
            }
        }
    }

    struct Filter: Hashable, Equatable, Identifiable {
        let id = UUID()

        let range: Range<Date>
    }
}

#Preview {

    @Previewable
    @State
    var filters: [DateRangeToolbar.Filter] = []

    @Previewable
    @State
    var isActive: Bool = false

    NavigationStack {
        Text("Hello, World!")
            .toolbar {
                DateRangeToolbar(isActive: $isActive, filters: $filters) {}
            }
    }
}
