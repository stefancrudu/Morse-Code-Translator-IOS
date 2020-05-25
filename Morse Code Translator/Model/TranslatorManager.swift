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
        var morseCode: String = ""
        for character in source {
            if let morseCharacter = MorseCodeAlphabet.alphabet[String(character).lowercased()]{
                morseCode += "\(morseCharacter) "
            }
        }
        return morseCode
    }

    
    public func playMorseSound(from source: String){
        let soundManager = SoundManager()
        let timeMap = getTimeMap(for: source)
        for characterTime in timeMap {
            if characterTime > 0 {
                soundManager.playSound(duration: characterTime)
            }else{
                Thread.sleep(forTimeInterval: TimeInterval(characterTime * -1))
            }
        }
    }

    public func getTimeMap(for source: String)-> [Float] {
        var timeMap:[Float] = []
        for character in source {
            switch character {
                case "·":
                    timeMap.append(Constants.sound.dotDuration)
                case "-":
                    timeMap.append(Constants.sound.dashDuration)
                case " ":
                    timeMap.append(Constants.sound.spaceBetweenCharacters)
                case "/":
                    timeMap.append(Constants.sound.spaceBetweenWords)
                default:
                    break
            }
        }
        return timeMap
    }
}
