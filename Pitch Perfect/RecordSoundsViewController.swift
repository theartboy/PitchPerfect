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
    var magColor: UIColor!
    var redColor: UIColor!
    var session: AVAudioSession!

    override func viewDidLoad() {
        super.viewDidLoad()
        var recordedAudio:RecordedAudio!
        magColor = UIColor(red: 0.6, green: 0.0, blue: 0.2, alpha: 1.0)
        redColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        session = AVAudioSession.sharedInstance()
    }
    override func viewWillAppear(animated: Bool) {
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        session.setActive(true, error: nil)
        userInterfaceReadyToRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    //instead of having buttons show and hide
    //user testing revealed the enable and disable approach
    //was more intuitive for users
    func userInterfaceReadyToRecord(){
        recordingLabel.textColor = magColor
        recordingLabel.text = "tap the mic to record"
        stopButton.enabled = false
        pauseButton.enabled = false
        microphoneButton.enabled = true
    }
    func userInterfaceRecording(){
        recordingLabel.textColor = redColor
        recordingLabel.text = "recording..."
        stopButton.enabled = true
        pauseButton.enabled = true
        microphoneButton.enabled = false
    }
    @IBAction func recordAudio(sender: UIButton) {
        userInterfaceRecording()
        if (audioRecorder == nil){
            let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
            
            var currentDateTime = NSDate()
            var formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            var pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
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
            userInterfaceReadyToRecord()
        }
    }
    @IBAction func pauseRecording(sender: AnyObject) {
        if (audioRecorder.recording){
            audioRecorder.pause()
            //did not use userInterfaceReadyToRecord because this use case is different that the others.
            pauseButton.enabled = false
            stopButton.enabled = true
            microphoneButton.enabled = true
            recordingLabel.textColor = magColor
            recordingLabel.text = "tap to resume recording"

        }else{
            audioRecorder.record()
            userInterfaceRecording()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="stopRecording"){
            let playSoundsVC:PlaySoundsViewController=segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        session.setActive(false, error: nil)
        userInterfaceReadyToRecord()
    }
}

