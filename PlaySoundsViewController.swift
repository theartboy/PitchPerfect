//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by John McCaffrey on 4/16/15.
//  Copyright (c) 2015 John McCaffrey. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController{

    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pitchUpButton: UIButton!
    @IBOutlet weak var pitchDownButton: UIButton!
    @IBOutlet weak var distortButton: UIButton!
    @IBOutlet weak var frogButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var playerDelegate: AVAudioPlayerDelegate!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    
    var audioFile: AVAudioFile!
    var session: AVAudioSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        session.setActive(true, error: nil)
        
        audioEngine = AVAudioEngine()
        
        audioFile = AVAudioFile(forReading:receivedAudio.filePathUrl,error:nil)
        stopButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioWithVariablePitchRate(0.0, _rate: 0.6)
    }

    @IBAction func playFastAudio(sender: UIButton) {
        playAudioWithVariablePitchRate(0.0, _rate: 3)

    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitchRate(1000, _rate: 1.0)
    }
    
    @IBAction func playVaderAudio(sender: AnyObject) {
        playAudioWithVariablePitchRate(-900, _rate: 1.0)
    }
    
    
    @IBAction func playDistortAudio(sender: AnyObject) {
        playAudioWithDistortion()
    }
    
    @IBAction func playFrogAudio(sender: AnyObject) {
        playAudioWithReverb()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        stopAudio()
        disableStopButton()
    }

    
    func playAudioWithReverb(){
        stopAudio()
        
        var mainMixerNode = AVAudioMixerNode()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var reverbEffect = AVAudioUnitReverb()
        reverbEffect.loadFactoryPreset(AVAudioUnitReverbPreset.Cathedral)
        reverbEffect.wetDryMix = 10
        
        var distortEffect = AVAudioUnitDistortion()
        distortEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.DrumsBitBrush)
        distortEffect.wetDryMix = 80
        
        var delayEffect = AVAudioUnitDelay()
        delayEffect.delayTime = 80
        delayEffect.wetDryMix = 10
        
        var changePitchRateEffect = AVAudioUnitTimePitch()
        changePitchRateEffect.pitch = -200
        changePitchRateEffect.rate = 0.9
        
        audioEngine.attachNode(mainMixerNode)
        audioEngine.attachNode(reverbEffect)
        audioEngine.attachNode(changePitchRateEffect)
        audioEngine.attachNode(distortEffect)
        audioEngine.attachNode(delayEffect)
        
        audioEngine.connect(audioPlayerNode, to: delayEffect, format: nil)
        audioEngine.connect(delayEffect, to: changePitchRateEffect, format: nil)
        audioEngine.connect(changePitchRateEffect, to: distortEffect, format: nil)
        audioEngine.connect(distortEffect, to: reverbEffect, format: nil)
        audioEngine.connect(reverbEffect, to: mainMixerNode, format: nil)
        audioEngine.connect(mainMixerNode, to: audioEngine.outputNode, format: nil)

        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: disableStopButton)
        audioEngine.startAndReturnError(nil)
        stopButton.enabled = true
        audioPlayerNode.play()
        
        
    }
    func playAudioWithVariablePitchRate(_pitch: Float, _rate: Float){
        stopAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        var changePitchRateEffect = AVAudioUnitTimePitch()
        
        changePitchRateEffect.pitch = _pitch
        changePitchRateEffect.rate = _rate
        
        audioEngine.attachNode(changePitchRateEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchRateEffect, format: nil)
        audioEngine.connect(changePitchRateEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: disableStopButton)
        audioEngine.startAndReturnError(nil)
        stopButton.enabled = true
        audioPlayerNode.play()
    }
    
    func playAudioWithDistortion(){
        stopAudio()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        //19
        var distortEffect = AVAudioUnitDistortion()
        distortEffect.loadFactoryPreset(AVAudioUnitDistortionPreset.SpeechGoldenPi)
        audioEngine.attachNode(distortEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: distortEffect, format: nil)
        audioEngine.connect(distortEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: disableStopButton)
        audioEngine.startAndReturnError(nil)
        stopButton.enabled=true
        audioPlayerNode.play()
        
    }
    
    func disableStopButton(){
        stopButton.enabled = false
    }
    
    func stopAudio(){
        audioEngine.stop()
        audioEngine.reset()
    }
    
}
