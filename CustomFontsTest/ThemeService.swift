//
//  ThemeService.swift
//  CustomFontsTest
//
//  Created by Eduard Kanevskii on 08.09.2023.
//

import UIKit

struct ThemeService {
    static var isSelected = false {
        didSet {
            backgroundColor = isSelected ? UIColor.red : UIColor.black
        }
    }
    static var backgroundColor = isSelected ? UIColor.red : UIColor.black
}
