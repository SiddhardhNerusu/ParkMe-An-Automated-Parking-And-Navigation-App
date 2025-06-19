import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.black)
                    .padding(.leading, 12)
            }

            TextField("", text: $text)
                .keyboardType(keyboardType)
                .padding(12)
                .foregroundColor(.black)
        }
        .background(Color(red: 240/255, green: 245/255, blue: 255/255))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
    }
}
