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
    var startDate: Date

    @Binding
    var endDate: Date

    var body: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: {
                showDatePicker.toggle()
            }) {
                Image(systemName: "calendar")
                    .font(.title)
                    .foregroundColor(.blue)
            }
            .popover(isPresented: $showDatePicker) {
                datePicker
                    .presentationCompactAdaptation(.popover)
            }
        }
    }

    private var datePicker: some View {
        VStack {
            Text("Filter Launch Dates")

            Spacer()

            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date])

            DatePicker("End Date", selection: $endDate, displayedComponents: [.date])
        }
        .padding()
    }
}

#Preview {

    @Previewable
    @State
    var startDate = Date()

    @Previewable
    @State
    var endDate = Date().addingTimeInterval(60 * 60 * 24 * 7)

    NavigationStack {
        Text("Hello, World!")
            .toolbar {
                DateRangeToolbar(startDate: $startDate, endDate: $endDate)
            }
    }
}
