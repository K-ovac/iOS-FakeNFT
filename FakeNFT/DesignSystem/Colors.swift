import UIKit

extension UIColor {
    // Creates color from a hex string
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let alpha, red, green, blue: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(red) / 255,
            green: CGFloat(green) / 255,
            blue: CGFloat(blue) / 255,
            alpha: CGFloat(alpha) / 255
        )
    }

    // MARK: - Dynamic Colors
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor { traits in
            return traits.userInterfaceStyle == .dark ? dark : light
        }
    }
    
    static func dynamicColor(lightHex: String, darkHex: String) -> UIColor {
        return dynamicColor(light: UIColor(hexString: lightHex), dark: UIColor(hexString: darkHex))
    }
    
    // MARK: - Background Colors
    
    static let background = dynamicColor(
        light: .white,
        dark: .black
    )
    
    static let secondaryBackground = dynamicColor(
        light: UIColor(hexString: "#F7F7F8"),
        dark: UIColor(hexString: "#1C1C1E")
    )
    
    static let tertiaryBackground = dynamicColor(
        light: UIColor(hexString: "#FFFFFF"),
        dark: UIColor(hexString: "#2C2C2E")
    )
    
    // MARK: - Text Colors
    
    static let textPrimary = dynamicColor(
        light: .black,
        dark: .white
    )
    
    static let textSecondary = dynamicColor(
        light: UIColor(hexString: "#6C6C70"),
        dark: UIColor(hexString: "#8E8E93")
    )
    
    static let textTertiary = dynamicColor(
        light: UIColor(hexString: "#3C3C43").withAlphaComponent(0.6),
        dark: UIColor(hexString: "#EBEBF5").withAlphaComponent(0.6)
    )
    
    static let textOnPrimary = dynamicColor(
        light: .white,
        dark: .black
    )
    
    // MARK: - Accent Colors
    
    static let primary = UIColor(red: 0 / 255, green: 122 / 255, blue: 255 / 255, alpha: 1.0) // Не меняется
    static let secondary = UIColor(red: 255 / 255, green: 193 / 255, blue: 7 / 255, alpha: 1.0) // Не меняется
    
    // MARK: - Segment Control
    
    static let segmentActive = dynamicColor(
        light: UIColor(hexString: "#1A1B22"),
        dark: .white
    )
    
    static let segmentInactive = dynamicColor(
        light: UIColor(hexString: "#F7F7F8"),
        dark: UIColor(hexString: "#2C2C2E")
    )
    
    // MARK: - UI Elements
    
    static let closeButton = dynamicColor(
        light: UIColor(hexString: "#1A1B22"),
        dark: .white
    )
    
    static let separator = dynamicColor(
        light: UIColor(hexString: "#E6E6E8"),
        dark: UIColor(hexString: "#38383A")
    )
    
    static let cardBackground = dynamicColor(
        light: .white,
        dark: UIColor(hexString: "#1C1C1E")
    )
    
    // MARK: - NFT Specific Colors
    
    static let ratingStarFilled = UIColor(hexString: "#FFA500")
    static let ratingStarEmpty = dynamicColor(
        light: UIColor(hexString: "#E6E6E8"),
        dark: UIColor(hexString: "#3A3A3C")
    )
    
    static let likeButtonActive = UIColor(hexString: "#FF3B30")
    static let likeButtonInactive = dynamicColor(
        light: UIColor(hexString: "#1A1B22"),
        dark: .white
    )
    
    // MARK: - Tab Bar
    
    static let tabBarItemTint = dynamicColor(
        light: .black,
        dark: .white
    )
    
    static let tabBarBackground = dynamicColor(
        light: .white,
        dark: .black
    )
    
    // MARK: - Navigation Bar
    
    static let navigationBarTint = dynamicColor(
        light: .black,
        dark: .white
    )
    
    // MARK: - Input Fields
    
    static let textFieldBackground = dynamicColor(
        light: UIColor(hexString: "#F7F7F8"),
        dark: UIColor(hexString: "#1C1C1E")
    )
    
    static let textFieldText = dynamicColor(
        light: .black,
        dark: .white
    )
    
    static let textFieldPlaceholder = dynamicColor(
        light: UIColor(hexString: "#8E8E93"),
        dark: UIColor(hexString: "#636366")
    )
    
    // MARK: - Buttons
    
    static let buttonPrimaryBackground = dynamicColor(
        light: .black,
        dark: .white
    )
    
    static let buttonPrimaryTitle = dynamicColor(
        light: .white,
        dark: .black
    )
    
    static let buttonSecondaryBackground = dynamicColor(
        light: .clear,
        dark: .clear
    )
    
    static let buttonSecondaryBorder = dynamicColor(
        light: .black,
        dark: .white
    )
    
    static let buttonSecondaryTitle = dynamicColor(
        light: .black,
        dark: .white
    )
    
    // MARK: - Alert
    
    static let alertBackground = dynamicColor(
        light: .white,
        dark: UIColor(hexString: "#1C1C1E")
    )
    
    static let alertTitle = dynamicColor(
        light: .black,
        dark: .white
    )
    
    static let alertMessage = dynamicColor(
        light: UIColor(hexString: "#8E8E93"),
        dark: UIColor(hexString: "#8E8E93")
    )
    
    static let alertActionDestructive = UIColor(hexString: "#FF3B30")
    static let alertActionCancel = dynamicColor(
        light: .black,
        dark: .white
    )
}
