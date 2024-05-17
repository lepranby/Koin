//  TransactionView.swift
//  Koin
//
//  Created by Aleksej Shapran on 12.05.24

import SwiftUI
import SwiftData

struct TransactionView: View {
    /// Environment properties
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    /// View Properties
    @State private var title: String = ""
    @State private var remarks: String = ""
    @State private var amount: Double = .zero
    @State private var dateAdded: Date = .now
    @State private var category: Category = .expense

    @State var tint: TintColor = tints.randomElement()!
    var editTransaction: Transaction?
    /// Appearance properties
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    @AppStorage("title") private var isTitleBig: Bool = false

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 16) {
                Text("Preview")
                    .font(.caption)
                    .foregroundStyle(.gray)
                    .hSpacing(.leading)

                TransactionCardView(transaction: .init(title: title.isEmpty ? "Title" : title, remarks: remarks.isEmpty ? "Remarks" : remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint))
                CustomSection("Title", "Magic Keyboard", value: $title)
                CustomSection("Remarks", "Apple product", value: $remarks)

                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Amount & Category")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    HStack(spacing: 16) {
                        HStack(spacing: 4) {
                            Text(currencySymbol)
                                .font(.callout.bold())
                            TextField("0.0", value: $amount, formatter: numberFormatter)
                                .keyboardType(.decimalPad)
                        }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(.background, in: .rect(cornerRadius: 10))
                            .frame(maxWidth: 130)
                        CategoryCheckBox()
                    }
                })
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("Date")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                    DatePicker("", selection: $dateAdded, displayedComponents: [.date]).datePickerStyle(.graphical)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.background, in: .rect(cornerRadius: 10))
                })
            }
            .padding(16)
            .scrollIndicators(.hidden)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    save()
                }, label: {
                    Text("Save")
                })
            }
        }
        .onAppear {
            if let editTransaction {
                title = editTransaction.title
                remarks = editTransaction.remarks
                dateAdded = editTransaction.dateAdded
                if let category = editTransaction.rawCategory {
                    self.category = category
                }
                amount = editTransaction.amount
                if let tint = editTransaction.tint {
                    self.tint = tint
                }
            }
        } 
        .navigationTitle("\(editTransaction == nil ? "Add" : "Edit") transaction")
        .scrollIndicators(.hidden)
        .preferredColorScheme(isDarkModeOn ? .dark : .light)
        .navigationBarTitleDisplayMode(isTitleBig ? .inline : .automatic)
        .background(.gray.opacity(0.16))
    }

    func save() {
        if editTransaction != nil {
            editTransaction?.title = title
            editTransaction?.remarks = remarks
            editTransaction?.amount = amount
            editTransaction?.category = category.rawValue
            editTransaction?.dateAdded = dateAdded
        } else {
            let transaction = Transaction(title: title, remarks: remarks, amount: amount, dateAdded: dateAdded, category: category, tintColor: tint)
            context.insert(transaction)
        }
        dismiss()
    }

    @ViewBuilder func CategoryCheckBox() -> some View {
        HStack(spacing: 10) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                HStack(spacing: 6) {
                    ZStack {
                        Image(systemName: "circle")
                            .font(.title3)
                            .foregroundStyle(appTint)
                        if self.category == category {
                            Image(systemName: "circle.circle.fill")
                                .font(.title3)
                                .foregroundStyle(appTint)
                        }
                    }
                    Text(category.rawValue).font(.caption)
                }
                .contentShape(.rect)
                .onTapGesture {
                    self.category = category
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .hSpacing(.leading)
        .background(.background, in: .rect(cornerRadius: 10))
    }

    @ViewBuilder func CustomSection(_ title: String, _ hint: String, value: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(title)
                .font(.caption)
                .foregroundStyle(.gray)
                .hSpacing(.leading)
            TextField(hint, text: value)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(.background, in: .rect(cornerRadius: 10))
        })
    }

    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }

}

#Preview {
    NavigationStack {
        TransactionView()
    }
}
