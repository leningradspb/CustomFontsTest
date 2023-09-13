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
    private var images: [UIImage] {
        var i: [UIImage] = []
        for index in 0...19 {
            i.append(UIImage(named: "\(index)")!)
        }
        return i
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        textField.inputView = NumericKeyboard(target: textField)
        view.backgroundColor = .black
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
        print(images.count)
        UserDefaults(suiteName: "group.kanevsky.testkeyboard")?.setValue("ThemeService.shared.backgroundColor", forKey: "text1")
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

