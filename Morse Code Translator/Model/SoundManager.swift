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
    
    var isPlaying: Bool = false
    var useFlashLight: Bool = false
    
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
    
    init(frequency: Float = 500, amplitude: Float = 0.3, outputVolume: Float = 0) {
        self.frequency = frequency
        self.amplitude = amplitude
        self.outputVolume = outputVolume
    }
    
    func playMorseSound(from source: String) {
        let timeMap = getTimeMap(for: source)
        let srcNode = getSourceNode()
        
        engine.attach(srcNode)
        engine.connect(srcNode, to: engine.mainMixerNode, format: inputFormat)
        engine.connect(engine.mainMixerNode, to: engine.outputNode, format: outputFormat)
        do {
            try engine.start()
        
            for timeCharacter in timeMap {
                if !isPlaying {
                    return
                }
                if timeCharacter > 0 {
                    engine.mainMixerNode.outputVolume = 0.9
                    if useFlashLight {
                        toggleTorch(on: true)
                    }
                    usleep(useconds_t(timeCharacter))
                    if useFlashLight {
                        toggleTorch(on: false)
                    }
                    engine.mainMixerNode.outputVolume = 0.0
                    usleep(useconds_t(Constants.spaceBetweenCharacters * -1))
                    
                }else{
                    usleep(useconds_t(Constants.spaceBetweenWords * -1))
                }
            }
            isPlaying = false
            engine.stop()
        } catch {
            print("Could not start engine: \(error)")
        }
        isPlaying = false
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
    
    private func getTimeMap(for source: String)-> [Int] {
        var timeMap:[Int] = []
        for character in source {
            switch character {
            case ".":
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
    
    private func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video) else { return }

        if device.hasTorch {
            do {
                try device.lockForConfiguration()

                if on == true {
                    device.torchMode = .on
                } else {
                    device.torchMode = .off
                }

                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        } else {
            print("Torch is not available")
        }
    }
}

// MARK: - Extension SoundManager

extension SoundManager {
    enum Constants {
        static let dotDuration: Int = 200000
        static let dashDuration: Int = 400000
        static let spaceBetweenCharacters: Int = -200000
        static let spaceBetweenWords: Int = -400000
    }
}
