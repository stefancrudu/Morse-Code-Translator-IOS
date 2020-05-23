//
//  MorseCodeAlphabet.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 23/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import Foundation

struct MorseCodeAlphabet {
    static var alphabet: [String: String] {
        return [
            "a" : "·-",
            "b" : "-···",
            "c" : "-·-·",
            "d" : "-··",
            "e" : "·",
            "f" : "··-·",
            "g" : "--·",
            "h" : "····",
            "i" : "··",
            "j" : "·---",
            "k" : "·-·",
            "l" : "·-··",
            "m" : "--",
            "n" : "-·",
            "o" : "---",
            "p" : "·--·",
            "q" : "--·-",
            "r" : "·-·",
            "s" : "···",
            "u" : "··-",
            "v" : "···-",
            "w" : "·--",
            "x" : "-··-",
            "y" : "-·--",
            "z" : "--··",
            
            "1" : "·----",
            "2" : "··---",
            "3" : "···--",
            "4" : "····-",
            "5" : "·····",
            "6" : "-····",
            "7" : "--···",
            "8" : "---··",
            "9" : "----·",
            "0" : "-----",
            
            " " : "/"
        ]
    }
}
