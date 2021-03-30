//
//  AddView.swift
//  iExpense
//
//  Created by Brandon Knox on 3/26/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business", "Personal"]
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                Button("Save") {
                    checkSave()
                }
            )
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func checkSave() {
        // test for errors and provide alerts
        guard isInteger(answer: self.amount) else {
            wordError(title: "Amount Error", message: "Amount entered is not an integer")
            return
        }
        
        // commit if valid
        if let actualAmount = Int(self.amount) {
            let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
            self.expenses.items.append(item)
            self.presentationMode.wrappedValue.dismiss()
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }

    func isInteger(answer: String) -> Bool {
        return Int(answer) != nil
    }
}



struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
