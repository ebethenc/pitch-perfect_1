//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by A H on 5/20/15.
//  Copyright (c) 2015 Bobiu. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController, AVAudioPlayerDelegate {

    /// Slow effect button
    @IBOutlet var PlaySlow: UIButton!
    
    /// Fast effect button
    @IBOutlet var PlayFast: UIButton!
    
    /// Chipmunk effect button
    @IBOutlet var PlayChip: UIButton!
    
    /// Pradator-Darthvader effect button
    @IBOutlet var PlayPredator: UIButton!
    
    /// Echo effect button
    @IBOutlet var PlayEcho: UIButton!
    
    /// Reverb effect button
    @IBOutlet var PlayReverbButton: UIButton!
    
    /// Stop button
    @IBOutlet var StopButton: UIButton!
    
    /// Model for receiving the recorded audio on the RecordAudio View
    var receivedAudio:RecordedAudio!
    
    /// The Audio Player Engine
    var audioEngine: AVAudioEngine!
    
    /// The Audio Player node to adding effects
    var audioPlayerNode: AVAudioPlayerNode!
    
    /// The Audio File object
    var audioFile: AVAudioFile!
    
    /**
        During the view load we access the audio file and create the Engine a Node players
    */
    override func viewDidLoad() {
        super.viewDidLoad()
          
        StopButton.hidden = true
       
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        //TODO: error control on accesing the file, i.e memory problems
        
        audioEngine = AVAudioEngine()
        audioPlayerNode = AVAudioPlayerNode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
        Generic function to playing effects
    
        :param: speed Value related to the effect that the user wants to play i.e the rate
    
        :param: effect Value representing the effect that should play (1=pitch, 2=rate, 3=echo, 4=reverv)
    
        - The pitch effect works for the chipmunk and vader effects
        - The rate effect works for slow and fast effects
    */
    func playSoundEffect(speed: Float, effect:Int)
    {
        audioPlayerNode = AVAudioPlayerNode()
        
        var audioNode = AVAudioNode()
        
        // effect for the pitch sound
        var pitchUnit = AVAudioUnitTimePitch()
        
        // effect for echo sound
        var echoSound = AVAudioUnitDelay()
        
        // effect for reverb
        var reverbSound = AVAudioUnitReverb()
        
        // Restart the Audio playing so effects do not overlap and starts from the beggining of the file
        audioEngine.stop()
        audioPlayerNode.stop()
        audioEngine.reset()
        audioEngine.attachNode(audioPlayerNode)
        
        switch effect
        {
            case 1:
                pitchUnit.pitch = speed
                audioNode = pitchUnit
    
            case 2:
                pitchUnit.rate = speed
                audioNode = pitchUnit
            
            case 3 :
                echoSound.feedback = speed
                audioNode = echoSound
            
            case 4:
                reverbSound.wetDryMix = speed
                reverbSound.loadFactoryPreset(AVAudioUnitReverbPreset.LargeHall)
                audioNode = reverbSound
            
            default:
                println("wrong call to function")
        }
        
        audioEngine.attachNode(audioNode)
        audioEngine.connect(audioPlayerNode, to: audioNode, format: nil)
        audioEngine.connect(audioNode, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil) { () -> Void in
            //println("estoy en completition")
            self.StopButton.hidden = true
         }
        
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
        
    }
    
    /// Play Slow Sound Effect
    @IBAction func playSlowRecording(sender: UIButton) {
        StopButton.hidden = false
        playSoundEffect(0.5, effect: 2)
       
    }

    /// Play Fast Sound Effect
    @IBAction func playFastRecording(sender: UIButton) {
        StopButton.hidden = false
        playSoundEffect(2.0, effect: 2)
       
    }

    /// Play Chipmunk Sound Effect
    @IBAction func playChipRecording(sender: UIButton) {
        StopButton.hidden = false
        playSoundEffect(1500, effect: 1)
        
    }
    
    /// Play Vader-Predator effect
    @IBAction func playPredatorRecording(sender: UIButton) {
        StopButton.hidden = false
        playSoundEffect(-1000, effect: 1)
       
    }
    
    /// Play echo sound effect
    @IBAction func playEchoRecording(sender: UIButton) {
        StopButton.hidden = false
        playSoundEffect(50, effect: 3)
       
    }
    
    /// Play Reverb Sound Effect
    @IBAction func playReverbRecording(sender: UIButton) {
        StopButton.hidden = false
        playSoundEffect(50, effect: 4)
       
    }
    
    /// Stop playing effect
    @IBAction func stopSound(sender: UIButton) {
        audioEngine.stop()
        audioPlayerNode.stop()
        audioEngine.reset()
    }
}
