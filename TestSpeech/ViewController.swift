//
//  ViewController.swift
//  TestSpeech
//
//  Created by Julien Boyer on 03/02/2020.
//  Copyright © 2020 Julien Boyer. All rights reserved.
//

import UIKit
import Speech


class ViewController: UIViewController {

    @IBOutlet weak var btnGo: UIButton!
    @IBOutlet weak var textSpeech: UILabel!
    
    let audioEngine = AVAudioEngine()
    let request = SFSpeechAudioBufferRecognitionRequest()

    var speakResultat: String?
    private var player: AVAudioPlayer?
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "fr-FR"))!
    var speechResult = SFSpeechRecognitionResult()
    var audioSession: AVAudioSession?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?

    
    @IBAction func goSpeech(_ sender: Any)  {
        print("ok")
        if !audioEngine.isRunning {
        print("Go Microphone...")
        self.audioSession = AVAudioSession.sharedInstance()
            do {
                try self.audioSession?.setCategory(AVAudioSession.Category.record)
                try self.audioSession?.setMode(AVAudioSession.Mode.measurement)
                try self.audioSession?.setActive(true)
                
            }  catch let error as NSError  {
                
                print(error)
            }
       
        var node = audioEngine.inputNode

        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat){
            buffer, _ in
            self.request.append(buffer)
        }
        // Configure request so that results are returned before audio recording is finished
        self.recognitionRequest?.shouldReportPartialResults = true
            self.request.requiresOnDeviceRecognition = false
            
        self.recognitionTask = speechRecognizer.recognitionTask(with: (request ??  nil)!) { result, error in
           
            var isFinal = false
            
            
            if let result = result {
                self.speakResultat = result.bestTranscription.formattedString
                self.textSpeech.text = result.bestTranscription.formattedString
                
                isFinal = result.isFinal
                self.speechResult = result
                print("resultat !!!")
                print(result.bestTranscription.formattedString)
            }
            
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                                
                node.removeTap(onBus: 0)
                print("Stop Microphone. !!")
                
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
            
        }
        
        print("Begin recording")
        audioEngine.prepare()
            do {
                try audioEngine.start()
            
            }  catch let error as NSError  {
                
                print(error)
            }
            

        
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

