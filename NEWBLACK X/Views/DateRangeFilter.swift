//
//  DateRangeFilter.swift
//  NEWBLACK X
//
//  Created by Dorian on 15/05/2025.
//

import SwiftUI
import Entities

struct DateRangeFilterView: View {

    @Binding
    var isActive: Bool

    @Binding
    var filters: [DateRangeFilter]

    @State
    private var startDate: Date = .now

    @State
    private var endDate: Date = .now

    @State
    private var showMissingFilterAlert = false

    var body: some View {
        List {
            Toggle(isOn: .init(get: {
                isActive
            }, set: { newValue in
                guard isActive || !filters.isEmpty else {
                    withAnimation {
                        showMissingFilterAlert.toggle()
                    }
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                    return
                }
                isActive = newValue
            })) {
                Text("Enable Filter")
            }
            Section("Select Date Range") {
                DatePicker("Start", selection: $startDate, displayedComponents: [.date])

                DatePicker("End", selection: $endDate, displayedComponents: [.date])

                Button("Add Date Range") {
                    withAnimation {
                        let range = startDate...endDate
                        filters.append(.init(range: range))
                        isActive = true
                        startDate = .now
                        endDate = .now
                    }
                }
                .shakeEffect(activate: showMissingFilterAlert, amount: 5, shakesPerUnit: 4)
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
                            isActive = false
                        }
                    }
                    .textCase(nil)
                    .font(.callout)
                }
            }
        }
    }
}

#Preview {

    @Previewable
    @State
    var isActive: Bool = false

    @Previewable
    @State
    var filters: [DateRangeFilter] = []

    DateRangeFilterView(isActive: $isActive, filters: $filters)
}
