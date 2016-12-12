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
    
    let midi = AKMIDI()
    
    //let sawtooth = AKTable.sawtooth // .triangle, etc.

    let square = AKTable(.square, size: 16)
    
    let triangle = AKTable(.triangle, size: 4096)
    
    let sine = AKTable(.sine, size: 4096)
    
    let sawtooth = AKTable(.sawtooth, size: 4096)
    
    var custom = AKTable(.sine, size: 512)

    
    var melodicSound: AKMIDINode?
    var oscillator:AKOscillatorBank
    var oscillator2:AKOscillator
    var mixer:AKMixer
    var envelope:AKAmplitudeEnvelope
    var lowPass:AKLowPassFilter
    var filter303:AKRolandTB303Filter
    var delay:AKVariableDelay
    var reverb:AKReverb
    
    var isPlaying = false


    
    init() {
        //AKSettings.bufferLength = .medium
        AKSettings.playbackWhileMuted = true
        
        //oscillator = AKOscillatorBank(waveform: AKTable(.sawtooth))
        oscillator = AKOscillatorBank(waveform: AKTable(.sawtooth))
        oscillator2 = AKOscillator(waveform: AKTable(.square))
        
        

        oscillator2.amplitude = 0.5
        oscillator2.frequency = 1000
        oscillator2.detuningOffset = 0
        oscillator2.start()
        

        
        melodicSound = AKMIDINode(node: oscillator)
        melodicSound?.enableMIDI(midi.client, name: "melodicSound midi in")
        
        mixer = AKMixer(oscillator, oscillator2);

        envelope = AKAmplitudeEnvelope(mixer)
        
        lowPass = AKLowPassFilter(mixer)
        lowPass.cutoffFrequency = 2000
        lowPass.resonance = 10
        filter303 = AKRolandTB303Filter(mixer)
        filter303.cutoffFrequency = 2000
        filter303.resonance = 10

        
        reverb = AKReverb(filter303)
        delay = AKVariableDelay(reverb)
       
        
        AudioKit.output = reverb
        AudioKit.start()
        

    }
    
    func play() {
        if (isPlaying) {
            oscillator.stop(noteNumber: 48)
            isPlaying = false
        } else {
            oscillator.play(noteNumber: 48, velocity: 127)
            isPlaying = true
        }
    
    }
    
    func setAttack(value: Float) {
        //envelope.attackDuration = Double(value * 3)
        oscillator.attackDuration = Double(value * 3)
        
    }
    func setDecay(value: Float) {
        //envelope.decayDuration = Double(value * 3)
        oscillator.decayDuration = Double(value * 3)
        
    }
    func setSustain(value: Float) {
        //envelope.sustainLevel = Double(value)
        oscillator.sustainLevel = Double(value)
    }
    
    func setRelease(value: Float) {
        //envelope.releaseDuration = Double(value * 3)
        oscillator.releaseDuration = Double(value * 3)
    }
    
    func setDetuningOsc2(value: Float) {
        oscillator2.frequency = Double(value * 200 - 100)
     }
    
    func setCutoff(value: Float) {
        filter303.cutoffFrequency = Double(value * 15000)
    }
    
    func setResonance(value: Float) {
        filter303.resonance = Double(value * 40)
    }

    
    
}
