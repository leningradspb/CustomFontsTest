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
    private let selectFontsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let mainStackView = VerticalStackView(distribution: .fillEqually, spacing: 8)
    private let shiftAndDeleteBackwardStack = HorizontalStackView(spacing: LayoutHelper.shiftAndDeleteBackwardSpace, heightConstraintValue: LayoutHelper.keyboardRowStackHeightConstraintValue)
    private let deleteBackwardButton = UIButton()
    private let numbersKey = UIView()
    private let spaceKey = UIButton()
    private let returnKey = UIButton()
    
    private var selectedFont: Fonts = .normal
    private var keyboards: [Keyboard] = []
    
//    private var selectedIndex = 0
    private var isAdditionalSymbolsSelected = false
    private let lightModeWhiteBackgroundImage = UIImage(named: "lightModeWhiteBackground")
    private let lightModeGrayBackgroundImage = UIImage(named: "lightModeGrayBackground")

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        setupSelectFontsCollectionView()
        setupMainStackView()
        setupDeleteBackwardButton()
        setupSpaceButton()
        loadKeyboardData()
        updateKeyboard()
    }
    
    private func setupSelectFontsCollectionView() {
        view.addSubview(selectFontsCollectionView)
        
        selectFontsCollectionView.delegate = self
        selectFontsCollectionView.dataSource = self
        selectFontsCollectionView.backgroundColor  = .white
        selectFontsCollectionView.showsHorizontalScrollIndicator = false
        selectFontsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        selectFontsCollectionView.register(FontSelectionCell.self, forCellWithReuseIdentifier: FontSelectionCell.identifier)
        
        if let flowLayout = selectFontsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//            flowLayout.minimumLineSpacing = 12
        }
        
        selectFontsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        selectFontsCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        selectFontsCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        selectFontsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        selectFontsCollectionView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupMainStackView() {
        view.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: selectFontsCollectionView.bottomAnchor, constant: 5).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -4).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func setupDeleteBackwardButton() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .default)
        let backward = UIImage(systemName: "delete.backward", withConfiguration: imageConfig)
        let backwardFill = UIImage(systemName: "delete.backward.fill", withConfiguration: imageConfig)
        
        deleteBackwardButton.tintColor = .black
        deleteBackwardButton.setImage(backward, for: .normal)
        deleteBackwardButton.setImage(backwardFill, for: .highlighted)
        deleteBackwardButton.setBackgroundImage(lightModeGrayBackgroundImage, for: .normal)
        deleteBackwardButton.setBackgroundImage(lightModeWhiteBackgroundImage, for: .highlighted)
        deleteBackwardButton.widthAnchor.constraint(equalToConstant: LayoutHelper.shiftAndDeleteBackwardWidth).isActive = true
        deleteBackwardButton.layer.cornerRadius = 4
        deleteBackwardButton.clipsToBounds = true
//                    deleteBackwardButton.backgroundColor = .gray
        deleteBackwardButton.addTarget(self, action: #selector(deleteBackward), for: .touchUpInside)
    }
    
    private func setupSpaceButton() {
        spaceKey.layer.cornerRadius = 8
        spaceKey.setBackgroundImage(lightModeWhiteBackgroundImage, for: .normal)
        spaceKey.setBackgroundImage(lightModeGrayBackgroundImage, for: .highlighted)
        spaceKey.clipsToBounds = true
        spaceKey.addTarget(self, action: #selector(insertSpace), for: .touchUpInside)
    }
    
    private func loadKeyboardData() {
        let fonts = Fonts.allCases
        fonts.forEach {
            keyboards.append(Keyboard(font: $0))
        }
        selectFontsCollectionView.reloadData()
    }
    
    private func updateKeyboard() {
        mainStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        shiftAndDeleteBackwardStack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        loadKeyboardBy(font: selectedFont)
    }
    
    private func loadKeyboardBy(font: Fonts) {
        let keyboard = Keyboard.init(font: selectedFont)
        
        let hasAdditionalSymbols = keyboard.additionalSymbols != nil
        
        if hasAdditionalSymbols && isAdditionalSymbolsSelected {
            //TODO логика со вторым экраном с цифрами
        } else {
            let isMediumWeight = keyboard.isMediumWeight
            for array in keyboard.lettersUsual {
                let rowStack = HorizontalStackView(distribution: .fillEqually, spacing: LayoutHelper.keyboardRowStackSpacing, alignment: .fill, heightConstraintValue: LayoutHelper.keyboardRowStackHeightConstraintValue)
                
                // Жесткий костыль, но пока сойдет так
                if mainStackView.arrangedSubviews.count == 0 {
                    array.forEach {
                        let button = createButton(title: $0, isMediumWeight: isMediumWeight)
                        rowStack.addArrangedSubview(button)
                    }
                    mainStackView.addArrangedSubview(rowStack)
                } else if mainStackView.arrangedSubviews.count == 1 {
                    let asdStack = HorizontalStackView(spacing: 0, heightConstraintValue: LayoutHelper.keyboardRowStackHeightConstraintValue)
                    asdStack.addArrangedSubview(createSpacer(space: LayoutHelper.asdStackPadding))
                    array.forEach {
                        let button = createButton(title: $0, isMediumWeight: isMediumWeight)
                        rowStack.addArrangedSubview(button)
                    }
                    asdStack.addArrangedSubview(rowStack)
                    asdStack.addArrangedSubview(createSpacer(space: LayoutHelper.asdStackPadding))
                    
                    mainStackView.addArrangedSubview(asdStack)
                } else if mainStackView.arrangedSubviews.count == 2 {
                    
                    let imageView = UIImageView(image: UIImage(systemName: "shift"))
                    imageView.backgroundColor = .gray
                    imageView.translatesAutoresizingMaskIntoConstraints = false
                    imageView.widthAnchor.constraint(equalToConstant: LayoutHelper.shiftAndDeleteBackwardWidth).isActive = true
                    shiftAndDeleteBackwardStack.addArrangedSubview(imageView)
                    
                    array.forEach {
                        let button = createButton(title: $0, isMediumWeight: isMediumWeight)
                        rowStack.addArrangedSubview(button)
                    }
                    
                    shiftAndDeleteBackwardStack.addArrangedSubview(rowStack)
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


extension KeyboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        keyboards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FontSelectionCell.identifier, for: indexPath) as! FontSelectionCell
        let index = indexPath.row
        if index < keyboards.count {
            let text: String = keyboards[index].sample  //keyboards[index].lettersUsual.first?.prefix(6).joined() ?? ""
            let isTapped = selectedFont == keyboards[index].font
            cell.update(text: text, isTapped: isTapped)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < keyboards.count {
            let keyboard = keyboards[indexPath.row]
            let newSelectedFont = keyboard.font
            guard newSelectedFont != selectedFont else { return }
            selectedFont = newSelectedFont
            updateKeyboard()
            collectionView.reloadData()
        }
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//        return UICollectionViewFlowLayout.automaticSize
////        return CGSize(width: 40, height: 60)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 0
    }
    
    
}


final class FontSelectionCell: UICollectionViewCell {
    private let fontNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(text: String, isTapped: Bool) {
        fontNameLabel.text = text
        if isTapped {
            contentView.backgroundColor = isDarkTheme ? .blue : .red  // .darkGray.withAlphaComponent(0.7)
        } else {
            contentView.backgroundColor = isDarkTheme ? .yellow : .orange // .gray.withAlphaComponent(0.1)
        }
    }
    
    private func setupCell() {
        contentView.layer.cornerRadius = 16
        contentView.addSubview(fontNameLabel)
        contentView.backgroundColor = .gray.withAlphaComponent(0.1)
        fontNameLabel.textColor = .black
        
        fontNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fontNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6).isActive = true
        fontNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6).isActive = true
        fontNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6).isActive = true
        fontNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
    }
}

let userTheme = UIScreen.main.traitCollection.userInterfaceStyle

var isDarkTheme: Bool {
    userTheme == .dark
}
