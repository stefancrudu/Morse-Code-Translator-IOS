//
//  SoundManager.swift
//  Morse Code Translator
//
//  Created by Stefan Crudu on 24/05/2020.
//  Copyright © 2020 Stefan Crudu. All rights reserved.
//

import Foundation
import AVFoundation


struct SoundManager {
    
    func playSound(duration: Float) {
        let frequency:Float = Constants.sound.frecvency
        let amplitude:Float = Constants.sound.amplitude
        let duration: Float = duration
        let twoPi = 2 * Float.pi
        let signal: (Float) -> Float = { (phase: Float) -> Float in
            return sin(phase)
        }
        let engine = AVAudioEngine()
        let mainMixer = engine.mainMixerNode
        let output = engine.outputNode
        let outputFormat = output.inputFormat(forBus: 0)
        let sampleRate = Float(outputFormat.sampleRate)
        let inputFormat = AVAudioFormat(commonFormat: outputFormat.commonFormat,
                                        sampleRate: outputFormat.sampleRate,
                                        channels: 1,
                                        interleaved: outputFormat.isInterleaved)
        var currentPhase: Float = 0
        let phaseIncrement = (twoPi / sampleRate) * frequency
        let srcNode = AVAudioSourceNode { _, _, frameCount, audioBufferList -> OSStatus in
            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            for frame in 0..<Int(frameCount) {
                let value = signal(currentPhase) * amplitude
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

        engine.attach(srcNode)
        engine.connect(srcNode, to: mainMixer, format: inputFormat)
        engine.connect(mainMixer, to: output, format: outputFormat)
        mainMixer.outputVolume = 0.8

        do {
            try engine.start()
            
            CFRunLoopRunInMode(.defaultMode, CFTimeInterval(duration), false)
            
            engine.stop()
        } catch {
            print("Could not start engine: \(error)")
        }

    }
    
}
