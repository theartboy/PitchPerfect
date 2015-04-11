//
//  ViewController.swift
//  Pitch Perfect
//
//  Created by John McCaffrey on 4/8/15.
//  Copyright (c) 2015 John McCaffrey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var recordingLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
//        TODO: show text recording in progress
//        TODO: record audio
        
//        println("recording audio")
        recordingLabel.hidden = !recordingLabel.hidden
        
    }

}

