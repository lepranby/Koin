//  DateFilterView.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI

struct DateFilterView: View {
    /// Appearance properties
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    
    @State var start: Date
    @State var end: Date
    var onSubmit: (Date, Date) -> ()
    var onClose: () ->  ()

    var body: some View {
        VStack(spacing: 2) {
            Text("Select period")
                .font(.callout).fontWeight(.semibold)
            DatePicker("Start date", selection: $start, displayedComponents: [.date])
            DatePicker("End date", selection: $end, displayedComponents: [.date])
            HStack(spacing: 20) {
                Button("Cancel") {
                    onClose()
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 12))
                .tint(Color.red.gradient)

                Button("Apply filter") {
                    onSubmit(start, end)
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.roundedRectangle(radius: 12))
                .tint(appTint.gradient)
            }
            .padding(.vertical, 10)
        }
        .padding(14)
        .background(.bar, in: .rect(cornerRadius: 32))
        .preferredColorScheme(isDarkModeOn ? .dark : .light)
        .padding(.horizontal, 18)
    }
}
