//
//  UIHelpersAndExtensions.swift
//  CKeyboard
//
//  Created by Eduard Kanevskii on 10.09.2023.
//

import UIKit

final class VerticalStackView: UIStackView {
    init(distribution: UIStackView.Distribution = .fill, spacing: CGFloat, alignment: UIStackView.Alignment = .fill) {
        super.init(frame: .zero)
        axis = .vertical
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
//        if let constraintValue {
//            translatesAutoresizingMaskIntoConstraints = false
//            heightAnchor.constraint(equalToConstant: constraintValue).isActive = true
//        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class HorizontalStackView: UIStackView {
    init(distribution: UIStackView.Distribution = .fill, spacing: CGFloat, alignment: UIStackView.Alignment = .fill, heightConstraintValue: CGFloat? = nil) {
        super.init(frame: .zero)
        axis = .horizontal
        self.distribution = distribution
        self.alignment = alignment
        self.spacing = spacing
        if let heightConstraintValue {
            translatesAutoresizingMaskIntoConstraints = false
            heightAnchor.constraint(equalToConstant: heightConstraintValue).isActive = true
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIInputViewController {
    func createSpacer(space: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.widthAnchor.constraint(equalToConstant: space).isActive = true
        return spacer
    }
}

struct LayoutHelper {
    static let asdStackPadding: CGFloat = 24
    static let keyboardRowStackHeightConstraintValue: CGFloat = 45
    static let keyboardRowStackSpacing: CGFloat = 6
    static let shiftAndDeleteBackwardSpace: CGFloat = 17
    static let shiftAndDeleteBackwardWidth: CGFloat = 50
}

extension UICollectionReusableView {
    static var identifier: String {
        "\(self)"
    }
}

extension UIColor
{
    convenience init?(hex: String?)
    {
        guard let hex = hex else {
            return nil
        }
        
        self.init(hex: hex)
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0)
    {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") { cString.removeFirst() }

        if (cString.count) != 6 {
            self.init(hex: "ffffff")
            return
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    public func hexString(_ includeAlpha: Bool = true) -> String
    {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getRed(&r, green: &g, blue: &b, alpha: &a)

        if includeAlpha {
            return String(format: "#%02X%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255), Int(a * 255))
        } else {
            return String(format: "#%02X%02X%02X", Int(r * 255), Int(g * 255), Int(b * 255))
        }
    }
}
