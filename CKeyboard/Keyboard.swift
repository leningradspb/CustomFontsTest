//
//  Keyboard.swift
//  CKeyboard
//
//  Created by Eduard Kanevskii on 10.09.2023.
//

import Foundation

enum Fonts: CaseIterable {
    case normal, square, squareFilled
}

struct Keyboard {
    let additionalSymbols: [[String]]?
    let lettersUsual: [[String]]
    let lettersUppercased: [[String]]?
    let isMediumWeight: Bool
    let font: Fonts
    let sample: String
    
    init(font: Fonts) {
        switch font {
        case .normal:
            additionalSymbols = FontKeyboardContent.normalAdditionalSymbols
            lettersUsual = FontKeyboardContent.normalLetters
            lettersUppercased = nil // TODO
            isMediumWeight = false
            self.font = font
            sample = FontKeyboardContent.normalLettersSample
        case .square:
            additionalSymbols = nil
            lettersUsual = FontKeyboardContent.squareLetters
            lettersUppercased = nil
            isMediumWeight = true
            self.font = font
            sample = FontKeyboardContent.squareLettersSample
        case .squareFilled:
            additionalSymbols = nil
            lettersUsual = FontKeyboardContent.squareFilledLetters
            lettersUppercased = nil
            isMediumWeight = true
            self.font = font
            sample = FontKeyboardContent.squareFilledLettersSample
        }
    }
}
