import SwiftUI

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    @Binding var showPassword: Bool

    var body: some View {
        ZStack(alignment: .trailing) {
            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.black)
                        .padding(.leading, 12)
                }
                Group {
                    if showPassword {
                        TextField("", text: $text)
                    } else {
                        SecureField("", text: $text)
                    }
                }
                .padding(12)
                .foregroundColor(.black)
            }

            Button {
                showPassword.toggle()
            } label: {
                Image(systemName: showPassword ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
                    .padding(.trailing, 12)
            }
        }
        .background(Color(red: 240/255, green: 245/255, blue: 255/255))
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black))
    }
}
