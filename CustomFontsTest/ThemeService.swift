//
//  ThemeService.swift
//  CustomFontsTest
//
//  Created by Eduard Kanevskii on 08.09.2023.
//

import UIKit

class ThemeService {
    static let shared = ThemeService()
    
    var themChanged: (()->())?
    
    init() {
        
    }
    
    var isSelected = false {
        didSet {
            backgroundColor = isSelected ? UIColor.red : UIColor.black
            themChanged?()
        }
    }
    
    var backgroundColor = UIColor.black
}
