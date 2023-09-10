//
//  KeyboardViewController.swift
//  CKeyboard
//
//  Created by Eduard Kanevskii on 05.09.2023.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    // отдельные стеки
    // кастомные размеры для разных клавиш
    // вью с выбором букв
    let selectFontsView = UIView()
    private let deleteBackwardButton = UIButton()
    private let numbersKey = UIView()
    private let spaceKey = UIButton()
    private let returnKey = UIButton()
    var selectedFont: Fonts = .normal
    let mainStackView = UIStackView()
    private let imageView = UIImageView(image: UIImage(named: "grd"))
    let fonts = Fonts.allCases
    var selectedIndex = 0
    var isAdditionalSymbolsSelected = false

    private let asdStackPadding: CGFloat = 24
    private let keyboardRowStackHeightConstraintValue: CGFloat = 45
    private let shiftAndDeleteBackwardSpace: CGFloat = 17
    private let shiftAndDeleteBackwardWidth: CGFloat = 50
//    let letterKeys = [
//        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
//        ["a", "s", "d", "f", "g","h", "j", "k", "l"],
//        ["z", "x", "c", "v", "b", "n", "m"],
//    ]
    // ["123", "􀆪", "📝", "space", "↩"]
    
//    let customLetters = [
//        ["\u{1D54F}", "\u{1D550}", "\u{1D54C}"],
//        ["\u{1D54F}", "\u{1D550}", "\u{1D54C}"],
//        ["123", "􀆪", "space", "↩"]
//    ]
    
//    let rectangleFillLetters = [
//        ["\u{1F180}", "\u{1F186}", "\u{1F174}", "\u{1F181}","\u{1F183}", "\u{1F188}", "\u{1F184}", "\u{1F178}", "\u{1F17E}", "\u{1F17F}"],
//        ["\u{1F170}", "\u{1F182}", "\u{1F173}", "\u{1F175}", "\u{1F176}", "\u{1F177}", "\u{1F179}", "\u{1F17A}", "\u{1F17B}"],
//        ["\u{1F189}", "\u{1F187}", "\u{1F172}", "\u{1F185}", "\u{1F171}", "\u{1F17D}", "\u{1F17C}", "𝔸"]
//    ]
    
//    let squareFillLetters = [
//        ["🆀", "🆆", "🅴", "🆁", "🆃", "🆈", "🆄", "🅸", "🅾", "🅿"],
//        ["🅰", "🆂", "🅳", "🅵", "🅶","🅷", "🅹", "🅺", "🅻"],
//        ["🆉", "🆇", "🅲", "🆅", "🅱", "🅽", "🅼"]
//    ]
//
//    let squareLetters = [
//        ["🅀", "🅆", "🄴", "🅁", "🅃", "🅈", "🅄", "🄸", "🄾", "🄿"],
//        ["🄰", "🅂", "🄳", "🄵", "🄶","🄷", "🄹", "🄺", "🄻"],
//        ["🅉", "🅇", "🄲", "🅅", "🄱", "🄽", "🄼"]
//    ]
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        // Add custom view sizing constraints here
//        stack.frame.size = view.frame.size
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.addSubview(imageView)
//        imageView.setImage(UIImage(named: "grd"), for: .normal)
//        view.backgroundColor = .red
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//
//        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
//
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.spacing = 8
//        let button = createButton(title: "\u{1066}")
//        let button1 = createButton(title: "\u{1D550}")
//        let button2 = createButton(title: "\u{1D54C}")
//        stack.addArrangedSubview(button)
//        stack.addArrangedSubview(button1)
//        stack.addArrangedSubview(button2)
        
//
//
        view.addSubview(selectFontsView)
        self.view.addSubview(mainStackView)
        selectFontsView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        selectFontsView.backgroundColor = .green
        selectFontsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        selectFontsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        selectFontsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        selectFontsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        mainStackView.topAnchor.constraint(equalTo: selectFontsView.bottomAnchor, constant: 5).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        
        deleteBackwardButton.addTarget(self, action: #selector(deleteBackward), for: .touchUpInside)
      
        updateKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        selectFontsView.addGestureRecognizer(tap)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let text = UserDefaults(suiteName: "group.kanevsky.testkeyboard")?.value(forKey: "text1") {
//            view.backgroundColor = .blue
        }
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        print(textInput)
        
       }
    
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        print(textInput)
        
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if selectedFont == .normal {
            selectedFont = .square
            selectedIndex = 1
        } else if selectedFont == .square {
            selectedFont = .squareFilled
            selectedIndex = 2
        } else {
            selectedFont = .normal
            selectedIndex = 0
        }
        updateKeyboard()
    }
    
    private func updateKeyboard() {
        mainStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        loadKeyboardBy(font: selectedFont)
    }
    
//    private func normalLetters() {
//        let selectedFont = fonts[selectedIndex]
//        for array in Keyboard.init(font: selectedFont).lettersUsual {
//            let s = UIStackView()
//            s.axis = .horizontal
//            s.distribution = .fillEqually
//            s.alignment = .center
//            s.spacing = 4
//            s.translatesAutoresizingMaskIntoConstraints = false
//            s.heightAnchor.constraint(equalToConstant: 40).isActive = true
//            mainStackView.addArrangedSubview(s)
//
//            array.forEach {
//                let button = createButton(title: $0)
//                s.addArrangedSubview(button)
//            }
//        }
//    }
    
    private func loadKeyboardBy(font: Fonts) {
        let selectedFont = fonts[selectedIndex]
        let keyboard = Keyboard.init(font: selectedFont)
        
        let hasAdditionalSymbols = keyboard.additionalSymbols != nil
        
        if hasAdditionalSymbols && isAdditionalSymbolsSelected {
            //TODO логика со вторым экраном с цифрами
        } else {
            for array in keyboard.lettersUsual {
                let s = UIStackView()
                s.axis = .horizontal
                s.distribution = .fillEqually
                s.alignment = .fill
                s.spacing = 4
                s.translatesAutoresizingMaskIntoConstraints = false
                s.heightAnchor.constraint(equalToConstant: 45).isActive = true
                
                // Жесткий костыль, но пока сойдет так
                if mainStackView.arrangedSubviews.count == 0 {
                    array.forEach {
                        let button = createButton(title: $0)
                        s.addArrangedSubview(button)
                    }
                    mainStackView.addArrangedSubview(s)
                } else if mainStackView.arrangedSubviews.count == 1 {
                    let asdStack = HorizontalStackView(spacing: 0, heightConstraintValue: keyboardRowStackHeightConstraintValue)
                    asdStack.addArrangedSubview(createSpacer(space: asdStackPadding))
                    array.forEach {
                        let button = createButton(title: $0)
                        s.addArrangedSubview(button)
                    }
                    asdStack.addArrangedSubview(s)
                    asdStack.addArrangedSubview(createSpacer(space: asdStackPadding))
                    
                    mainStackView.addArrangedSubview(asdStack)
                } else if mainStackView.arrangedSubviews.count == 2 {
                    let shiftAndDeleteBackwardStack = HorizontalStackView(spacing: shiftAndDeleteBackwardSpace, heightConstraintValue: keyboardRowStackHeightConstraintValue)
                    
                    let imageView = UIImageView(image: UIImage(systemName: "shift"))
                    imageView.backgroundColor = .gray
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.widthAnchor.constraint(equalToConstant: shiftAndDeleteBackwardWidth).isActive = true
                    shiftAndDeleteBackwardStack.addArrangedSubview(imageView)
                    
                    array.forEach {
                        let button = createButton(title: $0)
                        s.addArrangedSubview(button)
                    }
                    
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
////
                    let backward = UIImage(systemName: "delete.backward", withConfiguration: largeConfig)
                    let backwardFill = UIImage(systemName: "delete.backward.fill", withConfiguration: largeConfig)
                    
                    let lightBackgroundImage = UIImage(named: "lightBackground")
                    let lightBackgroundHighlightedImage = UIImage(named: "lightBackgroundHighlighted")
                    
                    

//                    let deleteimageView = UIImageView(image: UIImage(systemName: "delete.backward"))
//                    deleteimageView.translatesAutoresizingMaskIntoConstraints = false
                    deleteBackwardButton.tintColor = .black
                    
                    deleteBackwardButton.setImage(backward, for: .normal)
                    deleteBackwardButton.setImage(backwardFill, for: .highlighted)
                    deleteBackwardButton.setBackgroundImage(lightBackgroundImage, for: .normal)
                    deleteBackwardButton.setBackgroundImage(lightBackgroundHighlightedImage, for: .highlighted)
                    deleteBackwardButton.widthAnchor.constraint(equalToConstant: shiftAndDeleteBackwardWidth).isActive = true
                    deleteBackwardButton.layer.cornerRadius = 4
                    deleteBackwardButton.clipsToBounds = true
//                    deleteBackwardButton.backgroundColor = .gray
                    
                    
                    shiftAndDeleteBackwardStack.addArrangedSubview(s)
                    shiftAndDeleteBackwardStack.addArrangedSubview(deleteBackwardButton)
                    mainStackView.addArrangedSubview(shiftAndDeleteBackwardStack)
                }
            } // end of for each
            let spaceStack = UIStackView()
            spaceStack.axis = .horizontal
            spaceStack.addArrangedSubview(numbersKey)
            spaceStack.addArrangedSubview(spaceKey)
            spaceStack.addArrangedSubview(returnKey)
            
            spaceStack.translatesAutoresizingMaskIntoConstraints = false
            spaceStack.heightAnchor.constraint(equalToConstant: 45).isActive = true
            spaceStack.spacing = 4
            
            numbersKey.translatesAutoresizingMaskIntoConstraints = false
            numbersKey.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2).isActive = true
            numbersKey.backgroundColor = .black
            
            returnKey.translatesAutoresizingMaskIntoConstraints = false
            returnKey.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.2).isActive = true
            returnKey.setTitle("return", for: .normal)
            returnKey.setTitleColor(.black, for: .normal)
            returnKey.backgroundColor = .white
            
            spaceKey.backgroundColor = .purple
            
            mainStackView.addArrangedSubview(spaceStack)
        } // end hasAdditionalSymbols && isAdditionalSymbolsSelected
    } // end loadKeyboardBy(font
    

//
//    private func loadSquareFilledLetters() {
//        let selectedFont = fonts[selectedIndex]
//        for array in Keyboard.init(font: selectedFont).lettersUsual {
//            let s = UIStackView()
//            s.axis = .horizontal
//            s.distribution = .fillEqually
//            s.alignment = .center
//            s.spacing = 4
//            s.translatesAutoresizingMaskIntoConstraints = false
//            s.heightAnchor.constraint(equalToConstant: 40).isActive = true
//            mainStackView.addArrangedSubview(s)
//
//            array.forEach {
//                let button = createButton(title: $0)
//                s.addArrangedSubview(button)
//            }
//        }
//    }
    
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 30, weight: .medium) //UIFont(name: "Montague.ttf", size: 15)
        button.backgroundColor = .white  //UIColor(white: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.black, for: .normal)
//        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func didTapButton(sender: AnyObject) {
        let button = sender as! UIButton
//        button.titleLabel?.font =  .systemFont(ofSize: 50, weight: .bold) //UIFont(name: "Montague.ttf", size: 15)
//        button.titleLabel?.textColor = .blue
        let title = button.title(for: .normal)
        // "\u{1D63C}"
        let utf = "\u{1D63C}" //"哈哈123abc"  // "\u{00e2}"
        textDocumentProxy.insertText(title!)
//        textDocumentProxy.insertText("🅷🅾🆆 🆆🅴🅻🅻 🅳🅾🅴🆂 🆃🅷🅸🆂 🆆🅾🆁🅺?")
//        textDocumentProxy.
//        display.text
//        display?.text
//        self.setFontFamily(fontFamily: "FagoOfficeSans-Regular", forView: self.view!, andSubViews: true)
//        textDocumentProxy.insertText(title!)
//        advanceToNextInputMode()
    }
    
    @objc private func deleteBackward() {
        textDocumentProxy.deleteBackward()
    }
    
    private func createSpacer(space: CGFloat) -> UIView {
        let spacer = UIView()
        spacer.backgroundColor = .clear
        spacer.translatesAutoresizingMaskIntoConstraints = false
        spacer.widthAnchor.constraint(equalToConstant: space).isActive = true
        return spacer
    }
    
    func setFontFamily(fontFamily: String, forView view: UIView, andSubViews isSubViews: Bool) {

        if view is UILabel {
            let lbl: UILabel = view as! UILabel
            lbl.font = UIFont(name: fontFamily, size: lbl.font.pointSize)
        }
        if view is UIButton {
            let lbl: UIButton = view as! UIButton
            lbl.titleLabel?.font = .systemFont(ofSize: 10, weight: .thin) //UIFont(name: fontFamily, size: 12)!
        }

        if view is UITextField {
            let lbl: UITextField = view as! UITextField
            lbl.font = .systemFont(ofSize: 40, weight: .bold) //UIFont(name: fontFamily, size: 52)

        }

        if isSubViews {
            for sview: UIView in view.subviews {
                sview.backgroundColor = .red
//                self.setFontFamily(fontFamily: fontFamily, forView: sview, andSubViews: true)
            }
        }
    }
}

extension String {
    func utf8DecodedString()-> String {
        let data = self.data(using: .utf8)
        let message = String(data: data!, encoding: .nonLossyASCII) ?? ""
        return message
    }
    
    func utf8EncodedString()-> String {
        let messageData = self.data(using: .nonLossyASCII)
        let text = String(data: messageData!, encoding: .utf8) ?? ""
        return text
    }
}

enum Fonts: CaseIterable {
    case normal, square, squareFilled
    
//    var keyboard: Keyboard {
//        switch self {
//        case .normal:
//            return FontKeyboardContent.normalLetters
//        case .square:
//            return FontKeyboardContent.squareLetters
//        case .squareFilled:
//            return FontKeyboardContent.squareFillLetters
//        }
//    }
}

struct FontKeyboardContent {
    static let normalLetters = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g","h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"],
    ]
    static let normalAdditionalSymbols = [
        ["1", "2", "1", "2", "1", "2"],
        ["-", "-", "+", "="],
        [")", "!", "_"]
    ]
    
    static let squareFilledLetters = [
         ["🆀", "🆆", "🅴", "🆁", "🆃", "🆈", "🆄", "🅸", "🅾", "🅿"],
         ["🅰", "🆂", "🅳", "🅵", "🅶","🅷", "🅹", "🅺", "🅻"],
         ["🆉", "🆇", "🅲", "🆅", "🅱", "🅽", "🅼"]
     ]
     
     static let squareLetters = [
        ["🅀", "🅆", "🄴", "🅁", "🅃", "🅈", "🅄", "🄸", "🄾", "🄿"],
         ["🄰", "🅂", "🄳", "🄵", "🄶","🄷", "🄹", "🄺", "🄻"],
         ["🅉", "🅇", "🄲", "🅅", "🄱", "🄽", "🄼"]
     ]
}

struct Keyboard {
    let additionalSymbols: [[String]]?
    let lettersUsual: [[String]]
    let lettersUppercased: [[String]]?
    
    init(font: Fonts) {
        switch font {
        case .normal:
            additionalSymbols = FontKeyboardContent.normalAdditionalSymbols
            lettersUsual = FontKeyboardContent.normalLetters
            lettersUppercased = nil // TODO
        case .square:
            additionalSymbols = nil
            lettersUsual = FontKeyboardContent.squareLetters
            lettersUppercased = nil
        case .squareFilled:
            additionalSymbols = nil
            lettersUsual = FontKeyboardContent.squareFilledLetters
            lettersUppercased = nil
        }
    }
}


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
