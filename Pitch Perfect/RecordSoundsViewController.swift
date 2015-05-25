//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by A H on 5/15/15.
//  Copyright (c) 2015 Bobiu. All rights reserved.
//


import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{
    /// Button for the recording action
    @IBOutlet var recordButton: UIButton!
    
    /// Label with the current status/action possible
    @IBOutlet var recordingLabel: UILabel!
    
    /// Stop button: Stops the recording and saves it the gets you to PlaySound View - Shown only after recording started
    @IBOutlet var stopButton: UIButton!
    
    /// Pause button: Pauses the recording - Shown only after recording started
    @IBOutlet var pauseButton: UIButton!
    
    /// Restart button: Restarts the recording from 0 - Shown only after recording started
    @IBOutlet var redoButton: UIButton!
    
    /// Audio Recorder object
    var audioRecorder:AVAudioRecorder!
    
    /// Audio Session for the Recording
    var session:AVAudioSession!
    
    /// Instance of the Model for the Recorder Audio
    var recordedAudio:RecordedAudio!

    /// Path to the recording
    var dirPath:String!
    
    /// Control variable to implement the restart function
    var recordingActive = false
    
    /**
        During the view loding we get the path to store the recording and 
        initialize the recording session
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        // TODO: implement error control and interrumption handling
        // session.recordPermission()
    }
    
    /**
        Previous to the view Appearing we initialize the interface to the correct state
        - The Recording Button visible
        - The Label set to: **Press to Record**
        - The Control buttons (restart, pause, stop) not visible
    
    */
    override func viewWillAppear(animated: Bool) {
        
        redoButton.hidden = true
        pauseButton.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        recordingLabel.text="Press to Record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        1. We check if the Recording finished successfully 
        2. Prepare the Model (Recorded Audio) that we need in PlaySound View
        3. Perform the call to Segue with identifier **stopRecording**
    */
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
       
        if(flag){
            //save the audio
            recordedAudio = RecordedAudio(filePathURL: recorder.url,title: recorder.url.lastPathComponent!)
            
            //move to second scene
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("audio recording failed")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "stopRecording"){
            
            let playSoundVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            let data = sender as! RecordedAudio
            
            playSoundVC.receivedAudio = data
        
        }
    }
    
    
    /**
        Record the Audio from the user
    */
    @IBAction func recordAudio(sender: UIButton) {
       
        // Show the other buttons and indicate the user that we are recording
        recordingLabel.text="Recording ..."
        redoButton.hidden = false
        pauseButton.hidden = false
        stopButton.hidden = false
        recordButton.enabled=false
        
        
        // Validate if we are recording or not, this allows to implement the Pause function
        if(recordingActive){
            // If we are currently recording we just continue recording
            audioRecorder.record()
        }
        else
        {
            // else we set the flag to recording active
            recordingActive = true
            
            // Defining the new file name based on the current Date-time
            let currentDateTime = NSDate()
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"

            // then it is attached to the app directory and converted to URL format
            let pathArray = [dirPath, recordingName]
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            
            //println(filePath)
            
            // The Audio Recorder is created and initialized
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            // TODO: implement error control, i.e: the user does not gives permission on using the microphone
            audioRecorder.delegate = self
            // the delegate for the recording finish is implemented in this same class
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            
            // TODO: we should record in a temp file and copy it to a new "permantent" file only when the user presses stop, because we are leaving to much garbage
            // TODO: inside PlaySound we should implement the errase of the playing file (or the save with name) before we go back
        }
    }
    
    /**
        Stops the recording and resets the interface to the initial state
    */
    @IBAction func stopRecord(sender: UIButton) {
 
        redoButton.hidden = true
        pauseButton.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        recordingLabel.text="Press to Record"
        
        audioRecorder.stop()
        
        // Setting the flag to false again
        recordingActive = false
        
        session.setActive(false, error: nil)
        //TODO: error control on the close
    }
    
    /**
        Pauses the recording
    */
    @IBAction func pauseRecording(sender: UIButton) {
        
        audioRecorder.pause()
        recordButton.enabled = true
        recordingLabel.text="Press to continue Recording"
    }
    
    /**
        Allows the user to restart the recording again
    */
    @IBAction func restartRecording(sender: UIButton) {
        
        redoButton.hidden = true
        pauseButton.hidden = true
        stopButton.hidden = true
        recordButton.enabled = true
        recordingLabel.text="Press to Record again"
        
        // the active recording flag is set to false
        recordingActive = false
    }
}