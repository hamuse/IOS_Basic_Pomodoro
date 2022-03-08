//
//  ViewController.swift
//  pomodoro
//
//  Created by rs on 2022/03/07.
//

import UIKit

enum TimerStatus {
    case start
    case pasue
    case end
}
class ViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var datePickerView: UIDatePicker!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var toggleButton: UIButton!
    
    var duration = 60
    var timerStatus: TimerStatus = .end //타이머의 상태
    override func viewDidLoad() {
        super.viewDidLoad()
        configureToggleButton()
    }
    
    func setTimerInfoViewVisble(isHidden: Bool) {
        self.timerLabel.isHidden = isHidden
        self.progressView.isHidden = isHidden
    }

    func configureToggleButton() {
        self.toggleButton.setTitle("시작", for: .normal)
        self.toggleButton.setTitle("일시정지", for: .selected)
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePickerView.countDownDuration)
        switch self.timerStatus {
        case .end:
            self.timerStatus = .start
            self.setTimerInfoViewVisble(isHidden: false)
            self.datePickerView.isHidden = true
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            
        case .start:
            self.timerStatus = .pasue
            self.toggleButton.isSelected = false
        case .pasue:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
        }
    }
    
}

