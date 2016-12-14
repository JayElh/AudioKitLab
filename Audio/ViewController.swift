//
//  ViewController.swift
//  Audio
//
//  Created by Johan Lekberg on 13/11/16.
//  Copyright © 2016 Johan Lekberg. All rights reserved.
//

import UIKit
import AudioKit



class ViewController: UIViewController {

    var isPlaying = false
    let audioSource = AudioSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isPlaying = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func button(_ sender: UIButton) {
        audioSource.play()
    }
    
    @IBAction func setAttack(_ sender: UISlider) {
        audioSource.setAttack(value: sender.value)
    }

    @IBAction func setDecay(_ sender: UISlider) {
        audioSource.setDecay(value: sender.value)
    }
    
    @IBAction func setSustain(_ sender: UISlider) {
        audioSource.setSustain(value: sender.value)
    }
    
    @IBAction func setRelease(_ sender: UISlider) {
        audioSource.setRelease(value: sender.value)
    }
    
    @IBAction func setAttack2(_ sender: UISlider) {
        audioSource.setAttack2(value: sender.value)
    }
    
    @IBAction func setDecay2(_ sender: UISlider) {
        audioSource.setDecay2(value: sender.value)
    }
    
    @IBAction func setSustain2(_ sender: UISlider) {
        audioSource.setSustain2(value: sender.value)
    }
    
    @IBAction func setRelease2(_ sender: UISlider) {
        audioSource.setRelease2(value: sender.value)
    }
    
    
    @IBAction func changeFreq(_ sender: UISlider) {
        audioSource.setDetuningOsc2(value: sender.value)
    }
    @IBAction func setCutoff(_ sender: UISlider) {
        audioSource.setCutoff(value: sender.value)   }
    @IBAction func setResonance(_ sender: UISlider) {
        audioSource.setResonance(value: sender.value)
    }
    @IBAction func setVCO1Sine(_ sender: UIButton) {
        audioSource.setVCO1Waveform(value: "sine")
    }
    @IBAction func setVCO1Saq(_ sender: UIButton) {
        audioSource.setVCO1Waveform(value: "def")
    }
    @IBAction func setVCO1Square(_ sender: UIButton) {
        audioSource.setVCO1Waveform(value: "square")
    }
    @IBAction func setVCO1Tri(_ sender: UIButton) {
        audioSource.setVCO1Waveform(value: "triangle")
    }
    
    @IBAction func setVCO2Sine(_ sender: UIButton) {
        audioSource.setVCO2Waveform(value: "sine")
    }
    @IBAction func setVCO2Saw(_ sender: UIButton) {
        audioSource.setVCO2Waveform(value: "def")
    }
    @IBAction func setVCO2Square(_ sender: UIButton) {
        audioSource.setVCO2Waveform(value: "square")
    }
    @IBAction func setVCO2Tri(_ sender: UIButton) {
        audioSource.setVCO2Waveform(value: "triangle")
    }
    
    
    
}

