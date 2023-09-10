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
    private let mainStackView = VerticalStackView(distribution: .fillEqually, spacing: 8)
    private let deleteBackwardButton = UIButton()
    private let numbersKey = UIView()
    private let spaceKey = UIButton()
    private let returnKey = UIButton()
    
    var selectedFont: Fonts = .normal
    let fonts = Fonts.allCases
    var selectedIndex = 0
    var isAdditionalSymbolsSelected = false
    private let lightBackgroundImage = UIImage(named: "lightBackground")
    private let lightBackgroundHighlightedImage = UIImage(named: "lightBackgroundHighlighted")

    private let asdStackPadding: CGFloat = 24
    private let keyboardRowStackHeightConstraintValue: CGFloat = 45
    private let shiftAndDeleteBackwardSpace: CGFloat = 17
    private let shiftAndDeleteBackwardWidth: CGFloat = 50

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
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let text = UserDefaults(suiteName: "group.kanevsky.testkeyboard")?.value(forKey: "text1") {
//            view.backgroundColor = .blue
        }
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        print(textInput)
        
    }
    
    private func setupUI() {
        setupSelectFontsView()
        setupMainStackView()
        setupDeleteBackwardButton()
        setupSpaceButton()
        
      
        updateKeyboard()
    }
    
    private func setupSelectFontsView() {
        view.addSubview(selectFontsView)
        selectFontsView.translatesAutoresizingMaskIntoConstraints = false
        selectFontsView.backgroundColor = .green
        selectFontsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        selectFontsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        selectFontsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        selectFontsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        selectFontsView.addGestureRecognizer(tap)
    }
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: selectFontsView.bottomAnchor, constant: 5).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupDeleteBackwardButton() {
        deleteBackwardButton.addTarget(self, action: #selector(deleteBackward), for: .touchUpInside)
    }
    
    private func setupSpaceButton() {
        spaceKey.addTarget(self, action: #selector(insertSpace), for: .touchUpInside)
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
    
    private func loadKeyboardBy(font: Fonts) {
        let selectedFont = fonts[selectedIndex]
        let keyboard = Keyboard.init(font: selectedFont)
        
        let hasAdditionalSymbols = keyboard.additionalSymbols != nil
        
        if hasAdditionalSymbols && isAdditionalSymbolsSelected {
            //TODO логика со вторым экраном с цифрами
        } else {
            let isMediumWeight = keyboard.isMediumWeight
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
                        let button = createButton(title: $0, isMediumWeight: isMediumWeight)
                        s.addArrangedSubview(button)
                    }
                    mainStackView.addArrangedSubview(s)
                } else if mainStackView.arrangedSubviews.count == 1 {
                    let asdStack = HorizontalStackView(spacing: 0, heightConstraintValue: keyboardRowStackHeightConstraintValue)
                    asdStack.addArrangedSubview(createSpacer(space: asdStackPadding))
                    array.forEach {
                        let button = createButton(title: $0, isMediumWeight: isMediumWeight)
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
                        let button = createButton(title: $0, isMediumWeight: isMediumWeight)
                        s.addArrangedSubview(button)
                    }
                    
                    let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
////
                    let backward = UIImage(systemName: "delete.backward", withConfiguration: largeConfig)
                    let backwardFill = UIImage(systemName: "delete.backward.fill", withConfiguration: largeConfig)
                    
  
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
            
//            spaceKey.backgroundColor = .white
            spaceKey.layer.cornerRadius = 8
            spaceKey.setBackgroundImage(lightBackgroundHighlightedImage, for: .normal)
            spaceKey.setBackgroundImage(lightBackgroundImage, for: .highlighted)
            spaceKey.clipsToBounds = true
            
            mainStackView.addArrangedSubview(spaceStack)
        } // end hasAdditionalSymbols && isAdditionalSymbolsSelected
    } // end loadKeyboardBy(font
       
    func createButton(title: String, isMediumWeight: Bool) -> UIButton {
        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = isMediumWeight ? .systemFont(ofSize: 30, weight: .medium) : .systemFont(ofSize: 26, weight: .light) //UIFont(name: "Montague.ttf", size: 15)
        button.backgroundColor = .white  //UIColor(white: 1.0, alpha: 1.0)
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor.black, for: .normal)
//        button.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func didTapButton(sender: AnyObject) {
        let button = sender as! UIButton
//       todo: anything more beautiful
        let cacheFont = button.titleLabel?.font
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            button.titleLabel?.font = .systemFont(ofSize: (cacheFont?.pointSize ?? 30) + 5, weight: .medium)
        } completion: { isFinished in
            if isFinished {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    button.titleLabel?.font = cacheFont
                }
            }
        }
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
    
    @objc private func insertSpace() {
        textDocumentProxy.insertText(" ")
    }
}
