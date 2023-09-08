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
    var selectedFont: Fonts = .normal
    let stack = UIStackView()
    private let imageView = UIImageView(image: UIImage(named: "grd"))
    let letterKeys = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g","h", "j", "k", "l"],
        ["⬆️", "z", "x", "c", "v", "b", "n", "m", "⌫"],
        ["123", "􀆪", "📝", "space", "↩"]
    ]
    
    let customLetters = [
        ["\u{1D54F}", "\u{1D550}", "\u{1D54C}"],
        ["\u{1D54F}", "\u{1D550}", "\u{1D54C}"],
        ["123", "􀆪", "📝", "space", "↩"]
    ]
    
//    let rectangleFillLetters = [
//        ["\u{1F180}", "\u{1F186}", "\u{1F174}", "\u{1F181}","\u{1F183}", "\u{1F188}", "\u{1F184}", "\u{1F178}", "\u{1F17E}", "\u{1F17F}"],
//        ["\u{1F170}", "\u{1F182}", "\u{1F173}", "\u{1F175}", "\u{1F176}", "\u{1F177}", "\u{1F179}", "\u{1F17A}", "\u{1F17B}"],
//        ["\u{1F189}", "\u{1F187}", "\u{1F172}", "\u{1F185}", "\u{1F171}", "\u{1F17D}", "\u{1F17C}", "𝔸"]
//    ]
    
    let squareFillLetters = [
        ["🆀", "🆆", "🅴", "🆁", "🆃", "🆈", "🆄", "🅸", "🅾", "🅿"],
        ["🅰", "🆂", "🅳", "🅵", "🅶","🅷", "🅹", "🅺", "🅻"],
        ["🆉", "🆇", "🅲", "🆅", "🅱", "🅽", "🅼"]
    ]
    
    let squareLetters = [
        ["🅀", "🅆", "🄴", "🅁", "🅃", "🅈", "🅄", "🄸", "🄾", "🄿"],
        ["🄰", "🅂", "🄳", "🄵", "🄶","🄷", "🄹", "🄺", "🄻"],
        ["🅉", "🅇", "🄲", "🅅", "🄱", "🄽", "🄼"]
    ]
    
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
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
//        let button = createButton(title: "\u{1066}")
//        let button1 = createButton(title: "\u{1D550}")
//        let button2 = createButton(title: "\u{1D54C}")
//        stack.addArrangedSubview(button)
//        stack.addArrangedSubview(button1)
//        stack.addArrangedSubview(button2)
        
//
//
        view.addSubview(selectFontsView)
        self.view.addSubview(stack)
        selectFontsView.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        selectFontsView.backgroundColor = .green
        selectFontsView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        selectFontsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        selectFontsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        selectFontsView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        stack.topAnchor.constraint(equalTo: selectFontsView.bottomAnchor, constant: 5).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
      
        updateKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        selectFontsView.addGestureRecognizer(tap)
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
            selectedFont = .custom
        } else {
            selectedFont = .normal
        }
        updateKeyboard()
    }
    
    private func updateKeyboard() {
        stack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        switch selectedFont {
        case .normal:
            normalLetters()
            ThemeService.isSelected = false
            view.backgroundColor = ThemeService.backgroundColor
        case .custom:
            loadCustomLetters()
            ThemeService.isSelected = true
            view.backgroundColor = ThemeService.backgroundColor
        }
        
        
    }
    
    private func normalLetters() {
        for array in  letterKeys {
            let s = UIStackView()
            s.axis = .horizontal
            s.distribution = .fillEqually
            s.alignment = .center
            s.spacing = 4
            s.translatesAutoresizingMaskIntoConstraints = false
            s.heightAnchor.constraint(equalToConstant: 40).isActive = true
            stack.addArrangedSubview(s)
            
            array.forEach {
                let button = createButton(title: $0)
                s.addArrangedSubview(button)
            }
        }
    }
    
    private func loadCustomLetters() {
        for array in squareLetters {
            let s = UIStackView()
            s.axis = .horizontal
            s.distribution = .fillEqually
            s.alignment = .center
            s.spacing = 4
            s.translatesAutoresizingMaskIntoConstraints = false
            s.heightAnchor.constraint(equalToConstant: 40).isActive = true
            stack.addArrangedSubview(s)
            
            array.forEach {
                let button = createButton(title: $0)
                s.addArrangedSubview(button)
            }
        }
    }
    
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

enum Fonts {
    case normal, custom
}
