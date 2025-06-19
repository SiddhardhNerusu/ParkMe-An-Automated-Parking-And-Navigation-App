import SwiftUI

struct ColorTheme {

    static func primaryBackground(isNightMode: Bool) -> Color {
        isNightMode
            ? Color(red: 18/255, green: 18/255, blue: 18/255)
            : Color(red: 245/255, green: 245/255, blue: 245/255) 
    }

    static func cardBackground(isNightMode: Bool) -> Color {
        isNightMode
            ? Color(.secondarySystemBackground)
            : Color.white
    }

    static func fieldBackground(isNightMode: Bool) -> Color {
        isNightMode ? Color(.tertiarySystemFill) : Color(.systemGray6)
    
    }


    static func primaryText(isNightMode: Bool) -> Color {
        isNightMode ? .white : .black
    }

    static func secondaryText(isNightMode: Bool) -> Color {
        isNightMode ? Color(.lightGray) : Color(.darkGray)
    }


    static func buttonBackground() -> Color {
        Color(red: 1.0, green: 0.18, blue: 0.52)
    }

    static func toggleTint(isNightMode: Bool) -> Color {
        isNightMode ? .blue : .pink
    }


    static func iconColor(isNightMode: Bool) -> Color {
        isNightMode ? .white : .black
    }
    
    static func searchBarBackground(isNightMode: Bool) -> Color {
        isNightMode ? Color(.systemGray6) : Color.white
    }

    static func textFieldBackground(isNightMode: Bool) -> Color {
        isNightMode ? Color(.black) : Color(.white)
    }
    
    
    
}
