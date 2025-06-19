import SwiftUI

struct CustomLicensePlateField: View {
    @Binding var licensePlate: String

    var body: some View {
        ZStack {
            if licensePlate.isEmpty {
                Text("LICENSE PLATE")
                    .font(.system(size: 28, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
            }

            TextField("", text: $licensePlate)
                .keyboardType(.asciiCapable)
                .textCase(.uppercase)
                .onChange(of: licensePlate) { newValue in
                    licensePlate = String(newValue.prefix(7))
                }
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 12)
        }
        .frame(height: 55)
        .background(Color.yellow)
        .cornerRadius(10)
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
        .foregroundColor(.black)
    }
}
