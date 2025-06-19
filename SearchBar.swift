import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String
    var onConfirm: (Place) -> Void

    private var isNightMode: Bool {
        UserDefaults.standard.bool(forKey: "isNightMode")
    }

    var body: some View {
        TextField("Search", text: $searchText, onEditingChanged: { editing in
    
        })
        .padding()
        .frame(height: 44)
        .background(ColorTheme.fieldBackground(isNightMode: isNightMode))
        .foregroundColor(ColorTheme.primaryText(isNightMode: isNightMode))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
