//
//  SoundManager.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 24/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import Foundation
import AVFoundation


class SoundManager {
    
    private(set) var frequency: Float
    private(set) var amplitude: Float
    private(set) var outputVolume: Float
    
    private lazy var engine: AVAudioEngine = {
        let engine = AVAudioEngine()
        engine.mainMixerNode.outputVolume = outputVolume
        return engine
    }()
    
    private var outputFormat: AVAudioFormat {
        return engine.outputNode.inputFormat(forBus: 0)
    }
    
    private var inputFormat: AVAudioFormat? {
        return  AVAudioFormat(commonFormat: outputFormat.commonFormat,
                              sampleRate: outputFormat.sampleRate,
                              channels: 1,
                              interleaved: outputFormat.isInterleaved)
    }
    
    init(frequency: Float = 500, amplitude: Float = 0.3, outputVolume: Float = 0.8) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.outputVolume = outputVolume
    }
    
    func playMorseSound(from source: String) {
        let timeMap = getTimeMap(for: source)
        for characterTime in timeMap {
            if characterTime > 0 {
                playSound(duration: characterTime)
            } else {
                Thread.sleep(forTimeInterval: TimeInterval(characterTime * -1))
            }
        }
    }
    
    func playSound(duration: Float) {
        let srcNode = getSourceNode()
        
        engine.attach(srcNode)
        engine.connect(srcNode, to: engine.mainMixerNode, format: inputFormat)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: outputFormat)
        
        do {
            try engine.start()
            
            CFRunLoopRunInMode(.defaultMode, CFTimeInterval(duration), false)
            
            engine.stop()
        } catch {
            print("Could not start engine: \(error)")
        }
    }
    
    private func getSourceNode() -> AVAudioSourceNode {
        let twoPi = 2 * Float.pi
        
        var currentPhase: Float = 0
        let phaseIncrement = (twoPi / Float(outputFormat.sampleRate)) * frequency
        
        return AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let value = sin(currentPhase) * self.amplitude
                currentPhase += phaseIncrement
                if currentPhase >= twoPi {
                    currentPhase -= twoPi
                }
                if currentPhase < 0.0 {
                    currentPhase += twoPi
                }
                for buffer in ablPointer {
                    let buf: UnsafeMutableBufferPointer<Float> = UnsafeMutableBufferPointer(buffer)
                    buf[frame] = value
                }
            }
            return noErr
        }
    }
    
    private func getTimeMap(for source: String)-> [Float] {
        var timeMap:[Float] = []
        for character in source {
            switch character {
            case "·":
                timeMap.append(Constants.dotDuration)
            case "-":
                timeMap.append(Constants.dashDuration)
            case " ":
                timeMap.append(Constants.spaceBetweenCharacters)
            case "/":
                timeMap.append(Constants.spaceBetweenWords)
            default:
                break
            }
        }
        return timeMap
    }
}

extension SoundManager {
    enum Constants {
        static let dotDuration: Float = 0.20
        static let dashDuration: Float = 0.40
        static let spaceBetweenCharacters: Float = -0.20
        static let spaceBetweenWords: Float = -0.20
    }
}
