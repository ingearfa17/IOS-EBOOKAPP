//
//  DataViewController.swift
//  4070E091
//
//  Created by guest1 on 2018/12/14.
//  Copyright © 2018年 projectinge. All rights reserved.
//

import UIKit
import AVFoundation

class DataViewController: UIViewController, AVSpeechSynthesizerDelegate {

  
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var switchOfVoice: UISwitch!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    var speechSynthesizer = AVSpeechSynthesizer()
    var dataObject: String = ""
    var index = Int()
    var isInitial: Bool? = true
    var isFinished: Bool? = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // speech delegate
        speechSynthesizer.delegate = self
        switchOfVoice.isOn = false
        
        let obj: AnyObject = dataObject as AnyObject
        let content:String = obj.description
        var result:Array<String> = content.components(separatedBy: "|")
        self.titleLabel.text = result[0]
        self.authorLabel.text = result[1]
        self.contentImageView.image = UIImage(named: result[2])
        self.contentLabel!.text = result[3]
        
    }
    
    
    @IBAction func switchStateDidChange(_ sender: UISwitch) {
        if (sender.isOn == true) {
            
            if isInitial! || !isFinished! {
                textToSpeech(self.titleLabel.text!, preUtteranceDelay: nan(nil), postUtteranceDelay: 1)
                textToSpeech(self.contentLabel.text!, preUtteranceDelay: nan(nil), postUtteranceDelay: 0.1)
            }
            speechSynthesizer.continueSpeaking()
            
        } else {
            isInitial = false
            speechSynthesizer.pauseSpeaking(at: AVSpeechBoundary.word)
        }
        
    }
    

    func textToSpeech(_ inputSpeechText: String, preUtteranceDelay: Double, postUtteranceDelay: Double) {
        
        let myUtterance = AVSpeechUtterance(string: inputSpeechText)
        
        myUtterance.rate = 0.4//AVSpeechUtteranceMaximumSpeechRate/4 //0.45 //發音速度，數值越大讀的越快
        myUtterance.pitchMultiplier = 1.2 //音高, [0.5,2] default = 1.0
        myUtterance.volume = 1 // [0,1] default = 1
        
        if !preUtteranceDelay.isNaN {
            myUtterance.preUtteranceDelay = preUtteranceDelay
        }
        if !postUtteranceDelay.isNaN {
            myUtterance.postUtteranceDelay = postUtteranceDelay //讀完一段話後的停頓時間
        }
        myUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") //使用的聲音
        //myUtterance.voice = AVSpeechSynthesisVoice(identifier: "com.apple.ttsbundle.Mei-Jia-compact") //使用的聲音-2
        // check voice available for AVSpeechSynthesisVoice
        //print(AVSpeechSynthesisVoice.speechVoices())
        
        speechSynthesizer.speak(myUtterance)
    }
    
    // speechSynthesizer delegate
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if !isInitial! {
            self.switchOfVoice.isOn = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //if authorLabel.text == "Inge" {
            contentLabel.font = contentLabel.font.withSize(20)//UIFont(name: contentLabel.font.fontName, size: 20)
            contentLabel.textAlignment = .center
       // }
        
    }*/

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        speechSynthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }

}

