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

    let square = AKTable(.square, size: 16)
    
    let triangle = AKTable(.triangle, size: 4096)
    
    let sine = AKTable(.sine, size: 4096)
    
    let sawtooth = AKTable(.sawtooth, size: 4096)
    
    var custom = AKTable(.sine, size: 512)

    
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
        

        
        //melodicSound = AKMIDINode(node: oscillator)
        //melodicSoundB = AKMIDINode(node: oscillatorB)
        
        //melodicSound?.enableMIDI(midi.client, name: "melodicSound midi in")
        //melodicSoundB?.enableMIDI(midi.client, name: "melodicSound midi in")
        
        mixer = AKMixer(oscillator, oscillatorB);

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
        oscillatorB.detuningOffset = Double(value * 50 - 25)
     }
    
    func setCutoff(value: Float) {
        //filter303.cutoffFrequency = Double(value * 15000)
        lowPass.cutoffFrequency = Double(value * 15000)
    }
    
    func setResonance(value: Float) {
        //filter303.resonance = Double(value * 40)
        lowPass.resonance = Double(value * 40)
    }

    func receivedMIDINoteOn(noteNumber: MIDINoteNumber,
                            velocity: MIDIVelocity,
                            channel: Int) {
        oscillator.play(noteNumber: noteNumber, velocity: velocity)
        oscillatorB.play(noteNumber: noteNumber, velocity: velocity)
    }
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber,
                             velocity: MIDIVelocity,
                             channel: Int) {
        oscillator.stop(noteNumber: noteNumber)
        oscillatorB.stop(noteNumber: noteNumber)
    }
    func receivedMIDIPitchWheel(_ pitchWheelValue: Int, channel: Int) {
        //let bendSemi =  (Double(pitchWheelValue - 8192) / 8192.0) * midiBendRange
        //core.globalbend = bendSemi
    }
    
}
