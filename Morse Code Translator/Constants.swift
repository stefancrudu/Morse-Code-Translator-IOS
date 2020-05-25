//
//  Constants.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 21/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import Foundation

struct Constants {
    
    static let shareMessage = "Hi,\nI use Code Morse Translator from https://github.com/stefancrudu/Morse-Code-Translator-IOS. \nCheck it now!"
    
    struct colors {
        static let mainColor = "Main Color"
        static let secoundColor = "Secound Color"
        static let placeholderColorLight = "Placeholder Color Light"
        static let placeholderColorDark = "Placeholder Color Dark"
    }
        
    struct placeholders {
        static let placeholderTranslateFromTextView = "Type someting..."
        static let placeholderTranslatedLabel = "What do you want to translate in morse code?"
    }
    
    struct sound {
        static let frecvency: Float = 500
        static let amplitude: Float = 0.3
        static let dotDuration: Float = 0.20
        static let dashDuration: Float = 0.40
        static let spaceBetweenCharacters: Float = -0.20
        static let spaceBetweenWords: Float = -0.20
    }
}
