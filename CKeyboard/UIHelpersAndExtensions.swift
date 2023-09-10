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
    static let shiftAndDeleteBackwardSpace: CGFloat = 17
    static let shiftAndDeleteBackwardWidth: CGFloat = 50
}
