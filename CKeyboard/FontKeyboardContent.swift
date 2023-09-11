//
//  FontKeyboardContent.swift
//  CKeyboard
//
//  Created by Eduard Kanevskii on 10.09.2023.
//

import Foundation

struct FontKeyboardContent {
    static let normalLetters = [
        ["q", "w", "e", "r", "t", "y", "u", "i", "o", "p"],
        ["a", "s", "d", "f", "g","h", "j", "k", "l"],
        ["z", "x", "c", "v", "b", "n", "m"],
    ]
//    static let normalLettersSample = "sample"
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
