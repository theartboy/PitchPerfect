//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by John McCaffrey on 4/8/15.
//  Copyright (c) 2015 John McCaffrey. All rights reserved.
//
import UIKit

import AVFoundation
//Declared Globally


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var magColor = UIColor(red: 0.6, green: 0.0, blue: 0.2, alpha: 1.0)
    var redColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    var session = AVAudioSession.sharedInstance()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        session.setActive(true, error: nil)
        hideStuff()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func hideStuff(){
        recordingLabel.textColor = magColor
        recordingLabel.text = "tap the mic to record"
        stopButton.enabled = false
        pauseButton.enabled = false
        microphoneButton.enabled = true
    
    }
    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.textColor = redColor
        recordingLabel.text = "recording..."
        stopButton.enabled = true
        pauseButton.enabled = true
        microphoneButton.enabled = false
        if (audioRecorder == nil){
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
            
            var currentDateTime = NSDate()
            var formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            var pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
//            println(filePath)
            
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }else{
            audioRecorder.record()
            
        }
       
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(filePathUrl:recorder.url,title:recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was a failure")
            hideStuff()
        }
    }
    @IBAction func pauseRecording(sender: AnyObject) {
        if (audioRecorder.recording){
            audioRecorder.pause()
            pauseButton.enabled = false
            microphoneButton.enabled = true
            recordingLabel.textColor = magColor
            recordingLabel.text = "tap to resume recording"

        }else{
            audioRecorder.record()
            pauseButton.enabled = true
            microphoneButton.enabled = false
            recordingLabel.textColor = redColor
            recordingLabel.text = "recording..."

        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="stopRecording"){
            let playSoundsVC:PlaySoundsViewController=segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        session.setActive(false, error: nil)
        hideStuff()
    }
}

