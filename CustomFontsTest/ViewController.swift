//
//  ViewController.swift
//  CustomFontsTest
//
//  Created by Eduard Kanevskii on 05.09.2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

//    @IBOutlet weak var textField: UITextField!
//    private let phoneField = MaskedTextField()
    private let phoneField = UITextField()
    private let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        textField.inputView = NumericKeyboard(target: textField)
        view.backgroundColor = .white
//        phoneField. = .gray
//        phoneField.formatMask = "XXX XXX XX XX"
        phoneField.placeholder = "Type text"
//        phoneField.inputViewController = KeyboardViewController()
//        phoneField.textField.inputView =  NumericKeyboard(target: phoneField.textField)
        
        view.addSubview(phoneField)
        
        phoneField.snp.makeConstraints {
//            $0.height.equalTo(60)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        view.addSubview(button)
        
        button.snp.makeConstraints {
            $0.top.equalTo(phoneField.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
//        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.backgroundColor = .green.withAlphaComponent(0.5)
    }
    
    @objc private func buttonTapped() {
        
//        ThemeService.shared.backgroundColor = .blue
        // think about colors and images
        UserDefaults(suiteName: "group.kanevsky.testkeyboard")?.setValue("ThemeService.shared.backgroundColor", forKey: "text1")
    }


}

//class KeyboardViewController: UIInputViewController {
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let button = createButton(title: "A")
//        self.view.addSubview(button)
//    }
//    
//    func createButton(title: String) -> UIButton {
//        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
//        button.setTitle(title, for: .normal)
//        button.sizeToFit()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold) //UIFont(name: "Montague.ttf", size: 15)
//        button.backgroundColor = .black  //UIColor(white: 1.0, alpha: 1.0)
//        button.setTitleColor(UIColor.darkGray, for: .normal)
//        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
//        
//        return button
//    }
//    
//    @objc func didTapButton(sender: AnyObject) {
//        let button = sender as! UIButton
//        button.titleLabel?.font =  .systemFont(ofSize: 50, weight: .bold) //UIFont(name: "Montague.ttf", size: 15)
//        let title = button.title(for: .normal)
//        textDocumentProxy.insertText(title!)
//    }
//}

    //
    //  NumericKeyboard.swift
    //  Gorod
    //
    //  Created by Fedor Artemenkov on 15.07.2021.
    //  Copyright © 2021 RTG Soft. All rights reserved.
    //

    import UIKit

    class NumericKeyboard: UIInputView
    {
        private weak var target: UITextField?
        private var biometricHandler: (() -> Void)?

        private var numericButtons: [UIButton] = (0...9).map
        {
            let button = UIButton(type: .system)
            button.setTitle("\($0)", for: .normal)
            let fontSize: CGFloat = UIScreen.isIphone8orLess ? 32 : 36
            button.titleLabel?.font = UIFont(name: "Roboto-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize, weight: .regular)
            button.setTitleColor(UIColor(hex: "#37474F"), for: .normal)
            button.setTitleColor(UIColor(hex: "#37474F"), for: .highlighted)
            button.setBackgroundImage(UIColor(hex: "#F6F7F9").as1ptImage(), for: .highlighted)
            button.accessibilityTraits = [.keyboardKey]
            return button
        }

        private var deleteButton: UIButton = {
            let button = UIButton(type: .system)
//            button.setImage(#imageLiteral(resourceName: "keyboard_backspace_ic"), for: .normal)
            button.setBackgroundImage(UIColor(hex: "#F6F7F9").as1ptImage(), for: .highlighted)
            button.accessibilityTraits = [.keyboardKey]
            button.accessibilityLabel = "Backspace"
            return button
        }()
        
        lazy var biometricButton: UIButton = {
            let button = UIButton(type: .system)
            button.tintColor = UIColor(hex: "#9BA3B9")
            button.setBackgroundImage(UIColor(hex: "#F6F7F9").as1ptImage(), for: .highlighted)
            button.imageView?.contentMode = .scaleAspectFit
            button.accessibilityTraits = [.keyboardKey]
            button.accessibilityLabel = "FaceID"
            button.addTarget(self, action: #selector(didTapFaceButton), for: .touchUpInside)
            return button
        }()

        init(target: UITextField, biometricHandler: (() -> Void)? = nil)
        {
            self.target = target
            self.biometricHandler = biometricHandler
            
            super.init(frame: .zero, inputViewStyle: .keyboard)
            
            configure()
        }

        required init?(coder: NSCoder)
        {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func replaceTextAtTextRange(_ textRange: UITextRange, withString string: String)
        {
            guard let target = target else { return }
            
            let startPos = target.offset(from: target.beginningOfDocument, to: textRange.start)
            let length = target.offset(from: textRange.start, to: textRange.end)
            let selectedRange = NSRange(location: startPos, length: length)
            
            // FIXME: Работает только с кастомным MaskedTextField.
            textInput(target, shouldChangeCharactersIn: selectedRange, replacementString: string)
        }
        
        private func textInput(_ textInput: UITextInput, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            if let textField = textInput as? UITextField, let delegate = textField.delegate
            {
                return delegate.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? false
            }
            
            return false
        }
        
        private func deleteBackwardAtTextRange(_ textRange: UITextRange)
        {
            guard let target = target else { return }
            
            let startPos = target.offset(from: target.beginningOfDocument, to: textRange.start)
            
            guard startPos > 0 else { return }
            
            let selectedRange = NSRange(location: startPos - 1, length: 1)
            
            // FIXME: Работает только с кастомным MaskedTextField
            textInput(target, shouldChangeCharactersIn: selectedRange, replacementString: "")
            
            if let newPosition = target.position(from: textRange.start, offset: -1)
            {
                target.selectedTextRange = target.textRange(from: newPosition, to: newPosition)
            }
        }
    }

    // MARK: - Actions

    private extension NumericKeyboard
    {
        @objc private func didTapDigitButton(_ sender: UIButton)
        {
            guard let target = self.target else { return }
            guard target.isFirstResponder else { return }
            
            guard let text = sender.titleLabel?.text else { return }
            
            if let range = target.selectedTextRange
            {
//                let button = sender as! UIButton
                sender.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold)
                sender.title(for: .normal)
                
                target.font = .systemFont(ofSize: 20, weight: .bold)
//                textDocumentProxy.insertText(title!)
                replaceTextAtTextRange(range, withString: text)
            }
        }
        
        @objc private func didTapFaceButton()
        {
            guard let target = self.target else { return }
            guard target.isFirstResponder else { return }
            
            biometricHandler?()
        }

        @objc private func didTapDeleteButton()
        {
            guard let target = self.target else { return }
            guard target.isFirstResponder else { return }
            
            if let range = target.selectedTextRange
            {
                deleteBackwardAtTextRange(range)
            }
        }
    }

    // MARK: - Private initial configuration methods

    private extension NumericKeyboard
    {
        func configure()
        {
            backgroundColor = .white
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            allowsSelfSizing = true
            
            addButtons()
        }

        func addButtons()
        {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 2
            
            addSubview(stackView)
            
            stackView.snp.makeConstraints
            {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview().inset(UIScreen.isIphone8orLess ? 28 : 32)
                $0.bottom.equalToSuperview().inset(UIScreen.isIphone8orLess ? 12 : 44).priority(.medium)
            }

            for row in 0 ..< 3
            {
                let subStackView = createStackView(axis: .horizontal)
                stackView.addArrangedSubview(subStackView)
                
                subStackView.snp.makeConstraints
                {
                    $0.height.equalTo(UIScreen.isIphone8orLess ? 52 : 62)
                }

                for column in 0 ..< 3
                {
                    subStackView.addArrangedSubview(numericButtons[row * 3 + column + 1])
                }
            }

            let subStackView = createStackView(axis: .horizontal)
            stackView.addArrangedSubview(subStackView)
            
            subStackView.snp.makeConstraints
            {
                $0.height.equalTo(UIScreen.isIphone8orLess ? 52 : 62)
            }

            if biometricHandler != nil
            {
                switch BiometricHelper.biometricType
                {
                    case .face:
                        biometricButton.setImage(UIImage(named: "registration_faceID_ic"), for: .normal)
                        subStackView.addArrangedSubview(biometricButton)
                        
                    case .touch:
                        biometricButton.setImage(UIImage(named: "registration_touchID_ic"), for: .normal)
                        subStackView.addArrangedSubview(biometricButton)
                        
                    default:
                        let blank = UIView()
                        subStackView.addArrangedSubview(blank)
                }
            }
            else
            {
                let blank = UIView()
                subStackView.addArrangedSubview(blank)
            }

            subStackView.addArrangedSubview(numericButtons[0])
            subStackView.addArrangedSubview(deleteButton)
            
            for button in numericButtons
            {
                button.addTarget(self, action: #selector(didTapDigitButton(_:)), for: .touchUpInside)
            }
            
            deleteButton.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        }

        func createStackView(axis: NSLayoutConstraint.Axis) -> UIStackView
        {
            let stackView = UIStackView()
            stackView.axis = axis
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
            stackView.spacing = 2
            return stackView
        }
    }

    fileprivate extension UIColor {

        /// Converts this `UIColor` instance to a 1x1 `UIImage` instance and returns it.
        ///
        /// - Returns: `self` as a 1x1 `UIImage`.
        func as1ptImage() -> UIImage {
            UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
            setFill()
            UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
            UIGraphicsEndImageContext()
            return image
        }
    }

extension UIScreen
{
    static var isIphone8orLess: Bool
    {
        main.bounds.height <= 667.0
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


//
//  BiometricsHelper.swift
//  Gorod
//
//  Created by Ruslan on 20/02/2019.
//  Copyright © 2019 RTG Soft. All rights reserved.
//

import Foundation
import LocalAuthentication

final class BiometricHelper
{
    enum BiometricType: String
    {
        case none
        case touch = "Touch ID"
        case face = "Face ID"
    }
    
    static var biometricType: BiometricType
    {
        let authContext = LAContext()

        let _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch(authContext.biometryType)
        {
            case .none:
                return .none
                
            case .touchID:
                return .touch
                
            case .faceID:
                return .face
                
            default:
                return .none
        }
    }
}

//
//  MaskedTextField.swift
//  Gorod
//
//  Created by Fedor Artemenkov on 22.06.2021.
//  Copyright © 2021 RTG Soft. All rights reserved.
//

import UIKit

final class MaskedTextField: UIControl
{
    var text: String?
    {
        set(value)
        {
            cleanNumber = value ?? ""
            
            let text = format(cleanNumber)
            let cursor = filledCount(for: cleanNumber)
            applyFormatted(string: text, withCursor: cursor)
            setCursor(position: cursor)
        }

        get
        {
            return cleanNumber
        }
    }
    
    var placeholder = ""
    {
        didSet
        {
            placeholder = placeholder.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            //FIXME: хак, чтобы контрол получил верную ширину
            textField.attributedPlaceholder = NSAttributedString(string: format(""), attributes: [.kern: 4.5])
            
            let text = format(cleanNumber)
            let cursor = filledCount(for: cleanNumber)
            applyFormatted(string: text, withCursor: cursor)
            setCursor(position: 0)
        }
    }
    
    var formatMask = ""
    
    var maxNumbers: Int {
        formatMask.filter({"X".contains($0)}).count
    }
    
    var textColor: UIColor = .black {
        didSet {
        }
    }
    
    override var inputView: UIView?
    {
        set(value)
        {
            textField.inputView = value
        }
        
        get
        {
            return textField.inputView
        }
    }
    
    let textField = UITextField()
    
    private var cleanNumber = ""
    
    private let isSecured: Bool
    private let securedCharacter = "●"
    private let securedCharacterPlaceholder = "○"
    
    init(isSecured: Bool = false)
    {
        self.isSecured = isSecured
        
        super.init(frame: .zero)
        
        create()
        setupUI()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool
    {
        return super.becomeFirstResponder() || textField.becomeFirstResponder()
    }
    
    private func create()
    {
        addSubview(textField)
        
        textField.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func setupUI()
    {
        let fontSize: CGFloat = isSecured ? 14 : 18
        textField.font = .monospacedDigitSystemFont(ofSize: fontSize, weight: .bold)
        textField.tintColor = isSecured ? .clear : .black

        textField.defaultTextAttributes.updateValue(4.5, forKey: NSAttributedString.Key.kern)
        textField.delegate = self
        
        textField.textAlignment = .center
        
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.beginningOfDocument)
    }
    
    private func format(_ text: String) -> String
    {
        var result = ""
        
        var index = text.startIndex
        
        for maskCharacter in formatMask
        {
            var value = ""
            
            if maskCharacter == "X"
            {
                if index < text.endIndex
                {
                    value = isSecured ? securedCharacter : String(text[index])
                    index = text.index(after: index)
                }
                else if index < placeholder.endIndex
                {
                    value = isSecured ? securedCharacterPlaceholder : String(placeholder[index])
                    index = placeholder.index(after: index)
                }
            }
            else
            {
                value = String(maskCharacter)
            }
            
            result.append(value)
        }
        
        return result
    }
    
    private func filledCount(for text: String) -> Int
    {
        var counter: Int = 0
        var cursor: Int = 0
        
        for (index, maskCharacter) in formatMask.enumerated()
        {
            if maskCharacter == "X"
            {
                counter += 1
            }
            
            if counter == text.count + 1
            {
                cursor = index
                break
            }
            
            if index == formatMask.count - 1
            {
                cursor = index + 1
            }
        }
        
        return cursor
    }
    
    private func applyFormatted(string: String, withCursor cursor: Int)
    {
        let attributedText = NSMutableAttributedString(string: string, attributes: [.kern: 4.5])
        
        let inputRange = NSRange(location: 0, length: cursor)
        attributedText.addAttribute(.foregroundColor, value: UIColor.black, range: inputRange)
        
        let placeholderRange = NSRange(location: cursor, length: string.count - cursor)
        let foregroundColor = isSecured ? UIColor.black : UIColor(hex: "#ADB6C4")
        attributedText.addAttribute(.foregroundColor, value: foregroundColor, range: placeholderRange)
        
        DispatchQueue.main.async {
            self.textField.attributedText = attributedText
        }
    }
    
    private func setCursor(position offset: Int)
    {
        guard let position = textField.position(from: textField.beginningOfDocument, offset: offset) else { return }
        
        let range = textField.textRange(from: position, to: position)
        
        DispatchQueue.main.async {
            self.textField.selectedTextRange = range
        }
    }
}

extension MaskedTextField: UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        //FIXME: сейчас удаление идет с конца без учета позиции курсора
        if string.isEmpty, !cleanNumber.isEmpty
        {
            cleanNumber.removeLast()
        }
        else if cleanNumber.count < maxNumbers
        {
            cleanNumber.append(string)
        }
        
        let text = format(cleanNumber)
        let cursor = filledCount(for: cleanNumber)
        applyFormatted(string: text, withCursor: cursor)
        setCursor(position: cursor)
        
        sendActions(for: .valueChanged)
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        let cursor = filledCount(for: cleanNumber)
        setCursor(position: cursor)
        
        sendActions(for: .editingDidBegin)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        sendActions(for: .editingDidEnd)
    }
}
