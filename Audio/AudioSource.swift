//
//  File.swift
//  Audio
//
//  Created by Johan Lekberg on 12/12/16.
//  Copyright © 2016 Johan Lekberg. All rights reserved.
//

import Foundation
import AudioKit

class AudioSource {
    var oscillator = AKOscillator()
    var oscillator2 = AKOscillator()
    var envelope:AKAmplitudeEnvelope
    
    init() {
        oscillator.amplitude = 0.5
        oscillator.frequency = 1000
        oscillator.start()
        envelope = AKAmplitudeEnvelope(oscillator)
        envelope.attackDuration = 1
        envelope.decayDuration = 0.5
        envelope.sustainLevel = 0.5
        envelope.releaseDuration = 0.1
        
        AudioKit.output = envelope
        AudioKit.start()
        

    }
    
    func play() {
        if (envelope.isStarted) {
            envelope.stop()
        } else {
            envelope.start()
        }
    
    }
    
    func setAttack(value: Float) {
        envelope.attackDuration = Double(value * 10)
        
    }
    func setDecay(value: Float) {
        envelope.decayDuration = Double(value * 10)
        
    }
    func setSustain(value: Float) {
        envelope.sustainLevel = Double(value)
        
    }
    
    func setRelease(value: Float) {
        envelope.releaseDuration = Double(value * 10)
        
    }
    
    
}
