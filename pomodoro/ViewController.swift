//
//  ViewController.swift
//  pomodoro
//
//  Created by rs on 2022/03/07.
//

import UIKit

enum TimerStatus {
    case start
    case pause
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
    var timer: DispatchSourceTimer?
    var currentSeconds = 0
    
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
    
    func startTimer() {
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: .main) //UI와 관련된 작업은 main 쓰레드에서 구현 되어야 한다.
            self.timer?.schedule(deadline: .now(), repeating: 1)
            self.timer?.setEventHandler(handler: { [weak self] in
                self?.currentSeconds -= 1
                debugPrint(self?.currentSeconds)
                
                if self?.currentSeconds ?? 0 <= 0 {
                    // 타이머 종료
                    self?.stopTimer()
                }
            })
            self.timer?.resume()
        }
    }
    
    func stopTimer() {
        
        if self.timerStatus == .pause {
            self.timer?.resume()
        }
        
        self.timerStatus = .end
        self.cancelButton.isEnabled = false
        self.setTimerInfoViewVisble(isHidden: true)
        self.datePickerView.isHidden = false
        self.toggleButton.isSelected = false
        self.timer?.cancel()
        self.timer = nil //타이머를 정지 시킬때는 꼭 nil을 써서 정지 시켜 줘야한다. 그렇지 않으면 타이머가 계속 동작 할수가 있다.
        
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        switch self.timerStatus {
        case .start, .pause:
            self.stopTimer()
        default:
            break
        }
    }
    
    @IBAction func tapToggleButton(_ sender: UIButton) {
        self.duration = Int(self.datePickerView.countDownDuration)
        switch self.timerStatus {
        case .end:
            self.currentSeconds = self.duration
            self.timerStatus = .start
            self.setTimerInfoViewVisble(isHidden: false)
            self.datePickerView.isHidden = true
            self.toggleButton.isSelected = true
            self.cancelButton.isEnabled = true
            self.startTimer()
            
        case .start:
            self.timerStatus = .pause
            self.toggleButton.isSelected = false
            self.timer?.suspend()
            
        case .pause:
            self.timerStatus = .start
            self.toggleButton.isSelected = true
            self.timer?.resume()
            
        }
    }
    
}

