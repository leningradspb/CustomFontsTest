//
//  KeyboardViewController.swift
//  CKeyboard
//
//  Created by Eduard Kanevskii on 05.09.2023.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    let stack = UIStackView()
    
//    override func updateViewConstraints() {
//        super.updateViewConstraints()
//        // Add custom view sizing constraints here
//        stack.frame.size = view.frame.size
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 4
        let button = createButton(title: "\u{1D54F}")
        let button1 = createButton(title: "\u{1D550}")
        let button2 = createButton(title: "\u{1D54C}")
        stack.addArrangedSubview(button)
        stack.addArrangedSubview(button1)
        stack.addArrangedSubview(button2)
        
//        view.addSubview(button)
//        view.addSubview(button1)
        self.view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
//        stack.snp.makeConstraints {
//            $0.top.equalToSuperview()
//            $0.leading.equalToSuperview()
//            $0.trailing.equalToSuperview()
//            $0.height.equalTo(25)
//        }
//        self.textDocumentProxy.setMarkedText("12", selectedRange: NSRange(location: 0, length: 2))
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        print(textInput)
        
       }
    
    override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        print(textInput)
        
    }
    
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0,y: 0,width: 20,height: 20)
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .systemFont(ofSize: 50, weight: .bold) //UIFont(name: "Montague.ttf", size: 15)
        button.backgroundColor = .white  //UIColor(white: 1.0, alpha: 1.0)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        
        return button
    }
    
    @objc func didTapButton(sender: AnyObject) {
        let button = sender as! UIButton
        button.titleLabel?.font =  .systemFont(ofSize: 50, weight: .bold) //UIFont(name: "Montague.ttf", size: 15)
        button.titleLabel?.textColor = .blue
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
