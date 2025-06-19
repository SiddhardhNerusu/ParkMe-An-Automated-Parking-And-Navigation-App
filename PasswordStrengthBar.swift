import SwiftUI


enum PasswordStrength: String {
    case weak = "Weak"
    case medium = "Okay"
    case strong = "Strong"

    var color: Color {
        switch self {
        case .weak: return .red
        case .medium: return .yellow
        case .strong: return .green
        }
    }

    var widthFactor: CGFloat {
        switch self {
        case .weak: return 0.33
        case .medium: return 0.66
        case .strong: return 1.0
        }
    }
}


struct PasswordStrengthBar: View {
    var strength: PasswordStrength

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Capsule()
                    .frame(height: 8)
                    .foregroundColor(.gray.opacity(0.3))

                Capsule()
                    .frame(width: geometry.size.width * strength.widthFactor, height: 8)
                    .foregroundColor(strength.color)
                    .animation(.easeInOut(duration: 0.25), value: strength)
            }
        }
        .frame(height: 8)
    }
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255
        let g = Double((rgb >> 8) & 0xFF) / 255
        let b = Double(rgb & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
