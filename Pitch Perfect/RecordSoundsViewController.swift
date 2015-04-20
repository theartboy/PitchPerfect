//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by John McCaffrey on 4/8/15.
//  Copyright (c) 2015 John McCaffrey. All rights reserved.
//
////TODO: Remove old recordings when app closes to save disk space?
import UIKit

import AVFoundation
//Declared Globally


class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var microphoneButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(animated: Bool) {
        recordingLabel.hidden = false
        recordingLabel.text = "tap to record"
        stopButton.hidden = true
        microphoneButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func recordAudio(sender: UIButton) {
//        recordingLabel.hidden = false
        recordingLabel.text = "recording"
        stopButton.hidden = false
        microphoneButton.enabled = false
 /////////////////////
        //Inside func recordAudio(sender: UIButton)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        var currentDateTime = NSDate()
        var formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
       
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        }
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag){
            recordedAudio = RecordedAudio(filePathUrl:recorder.url,title:recorder.url.lastPathComponent!)
//            recordedAudio.filePathUrl=recorder.url
//            recordedAudio.title = recorder.url.lastPathComponent
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was a failure")
            recordingLabel.hidden = false
            recordingLabel.text = "tap to record"
            stopButton.hidden = true
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
        //Inside func stopAudio(sender: UIButton)
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        recordingLabel.hidden = true
        stopButton.hidden = true
    }
}

