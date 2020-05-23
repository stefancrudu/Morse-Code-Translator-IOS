//
//  TranslatorManager.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 23/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import Foundation

struct TranslatorManager {
    public func getMorseCode(from source: String) -> String{
        let characterArray = Array(source)
        var morseCode: String = ""
        for character in characterArray {
            if let morseCharacter = MorseCodeAlphabet.alphabet[String(character).lowercased()]{
                morseCode += "\(morseCharacter) "
            }
        }
        return morseCode
    }
}
