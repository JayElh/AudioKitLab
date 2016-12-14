//
//  File.swift
//  Audio
//
//  Created by Johan Lekberg on 12/12/16.
//  Copyright © 2016 Johan Lekberg. All rights reserved.
//

import Foundation
import AudioKit

class AudioSource: AKMIDIListener {
    
    let midi = AKMIDI()
    
    //let sawtooth = AKTable.sawtooth // .triangle, etc.

    let square = AKTable(.square)
    
    let triangle = AKTable(.triangle)
    
    let sine = AKTable(.sine)
    
    let sawtooth = AKTable(.sawtooth)
    
    var custom = AKTable(.sine, size: 512)

    var vco1:AKMorphingOscillatorBank
    var vco2:AKMorphingOscillatorBank
    
    
    var melodicSound: AKMIDINode?
    var melodicSoundB: AKMIDINode?
    var oscillator:AKOscillatorBank
    var oscillatorB:AKOscillatorBank
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
        oscillatorB = AKOscillatorBank(waveform: AKTable(.sawtooth))
        oscillator2 = AKOscillator(waveform: AKTable(.sine))
        
        oscillatorB.detuningOffset = 31

        oscillator2.amplitude = 0.5
        oscillator2.frequency = 1000
        oscillator2.detuningOffset = 0
        oscillator2.start()
        
        vco1 = AKMorphingOscillatorBank(waveformArray: [triangle, square, sine, sawtooth])
        vco2 = AKMorphingOscillatorBank(waveformArray: [triangle, square, sine, sawtooth])
        vco1.index = 1.1
        vco2.index = 1.1

        
        //melodicSound = AKMIDINode(node: oscillator)
        //melodicSoundB = AKMIDINode(node: oscillatorB)
        
        //melodicSound?.enableMIDI(midi.client, name: "melodicSound midi in")
        //melodicSoundB?.enableMIDI(midi.client, name: "melodicSound midi in")
        
        mixer = AKMixer(vco1, vco2, oscillator);

        envelope = AKAmplitudeEnvelope(mixer)
        
        lowPass = AKLowPassFilter(mixer)
        lowPass.cutoffFrequency = 2000
        lowPass.resonance = 10
        filter303 = AKRolandTB303Filter(mixer)
        filter303.cutoffFrequency = 1000 //oscillator2.plus(220.ak)
        filter303.resonance = 10

        
        reverb = AKReverb(lowPass)
        delay = AKVariableDelay(reverb)
       
        
        AudioKit.output = reverb
        AudioKit.start()
        
        let midi = AKMIDI()
        midi.createVirtualPorts()
        midi.openInput("JaySession 1")
        midi.addListener(self)
    }
    
    func play() {
        if (isPlaying) {
            oscillator.play(noteNumber: 48, velocity: 127)
            receivedMIDINoteOn(noteNumber: 48, velocity: 127, channel: 0)
            isPlaying = false
        } else {
            receivedMIDINoteOn(noteNumber: 48, velocity: 127, channel: 0)
            isPlaying = true
        }
    
    }
    
    func setAttack(value: Float) {
        vco1.attackDuration = Double(value * 3)
        
    }
    func setDecay(value: Float) {
        vco1.decayDuration = Double(value * 3)
        
    }
    func setSustain(value: Float) {
        vco1.sustainLevel = Double(value)
    }
    
    func setRelease(value: Float) {
        vco1.releaseDuration = Double(value * 3)
    }
    
    func setAttack2(value: Float) {
        vco2.attackDuration = Double(value * 3)
        
    }
    func setDecay2(value: Float) {
        vco2.decayDuration = Double(value * 3)
        
    }
    func setSustain2(value: Float) {
        vco2.sustainLevel = Double(value)
    }
    
    func setRelease2(value: Float) {
        vco2.releaseDuration = Double(value * 3)
    }

    
    
    func setDetuningOsc2(value: Float) {
        vco2.detuningOffset = Double(value * 50 - 25)
     }
    
    func setCutoff(value: Float) {
        lowPass.cutoffFrequency = Double(value * 15000)
    }
    
    func setResonance(value: Float) {
        lowPass.resonance = Double(value * 40)
    }

    func setVCO1Waveform(value: String) {
        switch value {
            case "sine":
                vco1.index = 2
            case "triangle":
                vco1.index = 0
            case "square":
                vco1.index = 1
            default:
                vco1.index = 3
        }
    }
    
    func setVCO2Waveform(value: String) {
        switch value {
        case "sine":
            vco2.index = 2
        case "triangle":
            vco2.index = 0
        case "square":
            vco2.index = 1
        default:
            vco2.index = 3
        }

    }
    
    
    
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber,
                            velocity: MIDIVelocity,
                            channel: Int) {
        //oscillator.play(noteNumber: noteNumber, velocity: velocity)
        vco1.play(noteNumber: noteNumber, velocity: velocity)
        vco2.play(noteNumber: noteNumber, velocity: velocity)
    }
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber,
                             velocity: MIDIVelocity,
                             channel: Int) {
        //oscillator.stop(noteNumber: noteNumber)
        vco1.stop(noteNumber: noteNumber)
        vco2.stop(noteNumber: noteNumber)
    }
    func receivedMIDIPitchWheel(_ pitchWheelValue: Int, channel: Int) {
        //let bendSemi =  (Double(pitchWheelValue - 8192) / 8192.0) * midiBendRange
        //core.globalbend = bendSemi
    }
    
}
