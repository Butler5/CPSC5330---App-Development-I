//
//  ViewController.swift
//  Module4ClockApp
//
//  Created by Adam Butler on 11/12/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet var currentClockLabel: UILabel!
    weak var timer: Timer?
    var clockTimer = Timer()
    var timeLeft : Int?
    var alarm: AVAudioPlayer?
    @IBOutlet var buttonText: UIButton!
    @IBOutlet var timeRemainingLabel: UILabel!
    @IBOutlet var selectTime: UIDatePicker!
    @IBOutlet var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentTime()
        timeRemainingLabel.text = ""
        
        guard let path = Bundle.main.path(forResource: "Alarm", ofType:"wav")
        else {print("not found")
            return}
        let url = URL(fileURLWithPath: path)
        do{
            alarm = try AVAudioPlayer(contentsOf: url)
        }catch{}
    }
    
    @IBAction func startTimerButton(_ sender: UIButton) {
        if (buttonText.currentTitle == "Stop Music") {
            stopMusic()
            buttonText.setTitle("Start", for: .normal)
        }
        else{
            let date = selectTime.date
            let components = Calendar.current.dateComponents([.hour, .minute], from: date)
            let hour = components.hour!
            let minute = components.minute!
            
            timeLeft = hour * 3600 + minute * 60
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(startCountDown) , userInfo: nil, repeats: true)
            buttonText.setTitle("Stop Music", for: .normal)
        }
    }
    
    private func getCurrentTime() {
        clockTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.currentTime) , userInfo: nil, repeats: true)
    }
    
    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM dd yyyy hh:mm:ss"
        currentClockLabel.text = formatter.string(from: Date())
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        let date = dateFormatter.string(from: Date())
        
        if(date.contains(dateFormatter.amSymbol)){
            background.image = UIImage(named:"daytime")
        }
        else {
            background.image = UIImage(named:"nighttime")
        }
    }
    
    @objc func startCountDown() {
        if (timeLeft! >= 0) {
            timeRemainingLabel.text = "(timeLeft)"
            timeLeft! -= 1
        }
        else{
            playMusic();
        }
    }
    
    func playMusic() {
        alarm?.play()
    }
    
    func stopMusic() {
        alarm?.pause()
    }
}
