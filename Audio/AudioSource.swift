//
//  File.swift
//  Audio
//
//  Created by Johan Lekberg on 12/12/16.
//  Copyright © 2016 Johan Lekberg. All rights reserved.
//

import Foundation
import AudioKit

class AudioSource: AKMIDIListener, AKKeyboardDelegate {
    
    let midi = AKMIDI()
    
    let square = AKTable(.square)
    
    let triangle = AKTable(.triangle)
    
    let sine = AKTable(.sine)
    
    let sawtooth = AKTable(.sawtooth)
    
    var vco1:AKMorphingOscillatorBank
    var vco2:AKMorphingOscillatorBank
    
    var vco1Offset: Int = 0
    var vco2Offset: Int = 0
    
    
    var melodicSound: AKMIDINode?
    var melodicSoundB: AKMIDINode?
    var oscillatorA:AKOscillatorBank
    var oscillatorB:AKOscillatorBank
    var oscillator2:AKOscillator
    var mixer:AKMixer
    var envelope:AKAmplitudeEnvelope
    //var lowPass:AKLowPassFilter
    //var filter303:AKRolandTB303Filter
    
    var filterSection: FilterSection
    var testEffects: TestEffects
    
    
    var delay:AKVariableDelay
    var reverb:AKReverb
    
    var isPlaying = false


    
    init() {
        //AKSettings.bufferLength = .medium
        AKSettings.playbackWhileMuted = true
        
        //oscillator = AKOscillatorBank(waveform: AKTable(.sawtooth))
        oscillatorA = AKOscillatorBank(waveform: AKTable(.sawtooth))
        oscillatorB = AKOscillatorBank(waveform: AKTable(.sawtooth))
        oscillator2 = AKOscillator(waveform: AKTable(.sine))

        oscillatorB.detuningOffset = 31

        oscillator2.amplitude = 2.5
        oscillator2.frequency = 10
        oscillator2.detuningOffset = 0
        oscillator2.start()
        
        vco1 = AKMorphingOscillatorBank(waveformArray: [triangle, square, sine, sawtooth])
        vco2 = AKMorphingOscillatorBank(waveformArray: [triangle, square, sine, sawtooth])
        vco1.index = 1.1
        vco2.index = 1.1

        //vco1Offset = 0
        //vco2Offset = 0
        
        //vco1.detuningOffset = oscillator2.
        
        //melodicSound = AKMIDINode(node: oscillatorA)
        //melodicSoundB = AKMIDINode(node: oscillatorB)
        
        //melodicSound?.enableMIDI(midi.client, name: "melodicSound midi in")
        //melodicSoundB?.enableMIDI(midi.client, name: "melodicSound midi in")
        
        mixer = AKMixer(vco1, vco2, oscillatorA);
        
        //AKAm

        envelope = AKAmplitudeEnvelope(mixer)
        
        
        filterSection = FilterSection(mixer)
        filterSection.output.start()
        //filterSection.lfoAmplitude(1000.0)
        
        testEffects = TestEffects(filterSection)
        testEffects.output.start()

        
        reverb = AKReverb(testEffects)
        delay = AKVariableDelay(reverb)
       
        
        AudioKit.output = reverb
        AudioKit.start()
        //Audiobus.start()
        
        let midi = AKMIDI()
        midi.createVirtualPorts()
        midi.openInput("JaySession 1")
        midi.addListener(self)
    }
    
    func play() {
        if (isPlaying) {
            //oscillator.play(noteNumber: 48, velocity: 127)
            receivedMIDINoteOff(noteNumber: 48, velocity: 127, channel: 0)
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
        vco2.detuningOffset = Double(value * 500 - 250)
     }
    
    func setCutoff(value: Float) {
        filterSection.cutoffFrequency = Double(value * 15000)
    }
    
    func setResonance(value: Float) {
        filterSection.resonance = Double(value)
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
        vco1.play(noteNumber: noteNumber + vco1Offset, velocity: velocity)
        vco2.play(noteNumber: noteNumber + vco2Offset, velocity: velocity)
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber,
                             velocity: MIDIVelocity,
                             channel: Int) {
        //oscillator.stop(noteNumber: noteNumber)
        vco1.stop(noteNumber: noteNumber + vco1Offset)
        vco2.stop(noteNumber: noteNumber + vco2Offset)
    }
    
    func receivedMIDIPitchWheel(_ pitchWheelValue: Int, channel: Int) {
        //let bendSemi =  (Double(pitchWheelValue - 8192) / 8192.0) * midiBendRange
        //core.globalbend = bendSemi
    }
    
    func receivedMIDIController(_ controller: Int, value: Int, channel: MIDIChannel) {
        let result: Float = Float(value) / Float(127)
        //debugPrint(value)
        //debugPrint(result)
        switch controller {
        case 1:
            setCutoff(value: result)
            
        case 71:
            setResonance(value: result)
            
        default:
            setCutoff(value: result)
        }
    }
    
    func noteOn(note: MIDINoteNumber) {
        receivedMIDINoteOn(noteNumber: note, velocity: 127, channel: 0)
    }
    
    func noteOff(note: MIDINoteNumber) {
        receivedMIDINoteOff(noteNumber: note, velocity: 127, channel: 0)
    }
}
