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
    @IBOutlet weak var backButton: UIButton!
    
    var audioPlayer: AVAudioPlayer!
    var playerDelegate: AVAudioPlayerDelegate!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
//    var audioPlayerNode = AVAudioPlayerNode()
    
    var audioFile: AVAudioFile!
//    let AVAudioSessionCategoryPlayAndRecord: String

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
        //            var filePathUrl = NSURL.fileURLWithPath(filePath)
        //            audioPlayer = AVAudioPlayer(contentsOfURL: filePathUrl, error: nil)
        //            audioPlayer.enableRate = true
        //            audioPlayer.prepareToPlay()
        //
        //        }else{
        //            println("file path is empty or incorrect")
        //        }
        let session = AVAudioSession.sharedInstance()
        //        var error: NSError?
        
        //        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error)
        //        session.overrideOutputAudioPort(AVAudioSessionPortOverride.None, error: &error)
        //        session.setActive(true, error: &error)
        session.setCategory(AVAudioSessionCategoryPlayback, error: nil)
//        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: nil)
        session.setActive(true, error: nil)
        
        audioEngine = AVAudioEngine()
        
//        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
//        audioPlayer.delegate = self
//        playerDelegate.audioPlayerDidFinishPlaying(audioPlayer, disableStopButton){
//            //
//        }
//        audioPlayer.enableRate = true
//        audioPlayer.prepareToPlay()
        
        audioFile = AVAudioFile(forReading:receivedAudio.filePathUrl,error:nil)
        stopButton.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
//        audioPlayer.stop()
//        audioPlayer.rate = 0.5
//        audioPlayer.currentTime = 0.0
//        audioPlayer.play()
//        playAudio()
        playAudioWithVariableRate(0.5)
    }

    @IBAction func playFastAudio(sender: UIButton) {
//        audioPlayer.stop()
//        audioPlayer.rate = 2.0
//        audioPlayer.currentTime = 0.0
//        audioPlayer.play()
//        playAudio()
        playAudioWithVariableRate(2)

    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playVaderAudio(sender: AnyObject) {
        playAudioWithVariablePitch(-800)
    }
    
    @IBAction func playDistortAudio(sender: AnyObject) {
        playAudioWithDistortion()
    }
    func playAudioWithVariablePitch(pitch: Float){
//        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: disableStopButton)
        audioEngine.startAndReturnError(nil)
        //        audioPlayerNode.volume = 1.0
        stopButton.enabled = true
        audioPlayerNode.play()
        
        
    }
    func playAudioWithVariableRate(rate: Float){
//        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changeRateEffect = AVAudioUnitTimePitch()
        changeRateEffect.rate = rate
        audioEngine.attachNode(changeRateEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: changeRateEffect, format: nil)
        audioEngine.connect(changeRateEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: disableStopButton)
        audioEngine.startAndReturnError(nil)
        //        audioPlayerNode.volume = 1.0
        stopButton.enabled = true
        audioPlayerNode.play()
        
        
    }
    func disableStopButton(){
        stopButton.enabled = false
    }
    func playAudioWithDistortion(){
//        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        //19
        var distortEffect = AVAudioUnitDistortion()
        distortEffect.loadFactoryPreset(AVAudioUnitDistortionPreset(rawValue: 19)!)
//        changePitchEffect.distort = pitch
        audioEngine.attachNode(distortEffect)
        
        
        audioEngine.connect(audioPlayerNode, to: distortEffect, format: nil)
        audioEngine.connect(distortEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: disableStopButton)
        audioEngine.startAndReturnError(nil)
        //        audioPlayerNode.volume = 1.0
        stopButton.enabled=true
        audioPlayerNode.play()
//        playNodeAudio(audioPlayerNode as AVAudioPlayerNode)
        
    }
    @IBAction func stopAudio(sender: UIButton) {
//        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        stopButton.enabled = false
    }

//    func playAudio() {
//        stopButton.enabled = true
//
//        audioEngine.stop()
//        audioEngine.reset()
//        audioPlayer.stop()
//        audioPlayer.currentTime = 0.0
////        audioPlayer.volume = 1.0
//        audioPlayer.play()
//    }

    @IBAction func backToRecord(sender: AnyObject) {
        audioEngine.stop()
        audioEngine.reset()
//        audioPlayer.stop()
    }
   
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
