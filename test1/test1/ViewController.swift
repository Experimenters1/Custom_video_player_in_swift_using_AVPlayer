//
//  ViewController.swift
//  test1
//
//  Created by huy on 6/15/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var vieo_view_test: UIView!
    
    @IBOutlet weak var Play_test: UIButton!
    
    @IBOutlet weak var sliderTime_test: UISlider!
    
    @IBOutlet weak var CurrentTime_test: UILabel!
    
    @IBOutlet weak var CurrentTime: UILabel!
    
    @IBOutlet weak var Mute_test: UIButton!
    
    public var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    var isVideoPlaying = false
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "button")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        button.addTarget(self, action: #selector(onBtnPlay_test(_:)), for: .touchUpInside)

        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sliderTime_test.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        sliderTime_test.isUserInteractionEnabled = false
        setupPlayer()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = vieo_view_test.bounds
    }

    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                print("began")
                player.pause()
                break
                // handle drag began
            case .moved:
                print("moved")
                break
                // handle drag moved
            case .ended:
                if isVideoPlaying {
                    player.play()
                    self.pausePlayButton.isHidden = true
                } else {
                    player.pause()
                    self.pausePlayButton.isHidden = false
                }
                print("ended ")
                break
                // handle drag ended
            default:
                break
            }
        }
    }
    
    func setupPlayer() {
        activityIndicatorView.startAnimating()
        let fileManager = FileManager.default
        guard let documentsFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        var myString = "IMG_0142.MOV"
        let url = documentsFolderURL.appendingPathComponent(myString)
        
        player = AVPlayer(url: url)
        player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        
        onBtnPlayPause()
        addObserverToVideoisEnd()
        addTimeObserver()
        
        playerLayer = AVPlayerLayer(player: player)
//        playerLayer.videoGravity = .resizeAspect
//        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.videoGravity = .resize
        vieo_view_test.layer.addSublayer(playerLayer)
        setupPlayButtonInsideVideoView()
    }
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { [weak self] time in
            guard let currentItem = self!.player.currentItem else {return}
            if self?.player.currentItem!.status == .readyToPlay {
                self?.sliderTime_test.minimumValue = 0
                self?.sliderTime_test.maximumValue = Float(currentItem.duration.seconds)
                self?.sliderTime_test.value = Float(currentItem.currentTime().seconds)
                self?.CurrentTime_test.text = currentItem.currentTime().durationText
            }
        }
    }
    
    func setupPlayButtonInsideVideoView() {
        vieo_view_test.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: vieo_view_test.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: vieo_view_test.centerYAnchor).isActive = true

        vieo_view_test.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: vieo_view_test.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: vieo_view_test.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.someAction (_:)))
        self.vieo_view_test.addGestureRecognizer(gesture)
    }
    
    @objc func someAction(_ sender: UITapGestureRecognizer){
        print("view was clicked")
        onBtnPlayPause()
    }
    
    func addObserverToVideoisEnd() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playerEndPlay() {
        onBtnPlayPause()
        print("Player ends playing video")
        player.seek(to: CMTime.zero)
        player.pause()
    }
    
    func onBtnPlayPause() {
        if isVideoPlaying {
            player.pause()
            Play_test.setImage(UIImage(named: "button"), for: .normal)
            pausePlayButton.setImage(UIImage(named: "mute"), for: .normal)
            self.pausePlayButton.isHidden = false
        } else {
            player.play()
            Play_test.setImage(UIImage(named: "Frame_3"), for: .normal)
            pausePlayButton.setImage(UIImage(named: "unmute"), for: .normal)
        }
        isVideoPlaying = !isVideoPlaying

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 4) {
            if self.isVideoPlaying {
                self.pausePlayButton.isHidden = true
            }
        }
    }
    
    @IBAction func onBtnPlay_test(_ sender: Any) {
        onBtnPlayPause()
        let fileManager = FileManager.default
        guard let documentsFolderURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        print("huy: \(documentsFolderURL)")
    }
    
    @IBAction func onbtnForward_test(_ sender: UIButton) {
        guard let duration = player.currentItem?.duration else {
            return
        }
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let newTime = currentTime + 5.0
        if newTime < (CMTimeGetSeconds(duration) - 5.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            player.seek(to: time)
        }
    }
    
    @IBAction func onBtnBackword_test(_ sender: Any) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var newTime = currentTime - 5.0

        if newTime < 0 {
            newTime = 0
        }

        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player.seek(to: time)
    }
    
    @IBAction func sliderValueChange_test(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    
    @IBAction func onBtnMute_test(_ sender: UIButton) {
        Mute_test.isSelected.toggle()
        if Mute_test.isSelected {
            player.isMuted = true
            Mute_test.setImage(UIImage(named: "mute"), for: .normal)
        } else {
            player.isMuted = false
            Mute_test.setImage(UIImage(named: "unmute"), for: .normal)
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.CurrentTime.text = player.currentItem!.duration.durationText
        }

        if keyPath == "currentItem.loadedTimeRanges" {
//            pausePlayButton.isHidden = false
            sliderTime_test.isUserInteractionEnabled = true
            activityIndicatorView.stopAnimating()
        }
    }
    
}

extension CMTime {
    var durationText: String {
        let totalSeconds = CMTimeGetSeconds(self)
        let hours: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds: Int = Int(totalSeconds.truncatingRemainder(dividingBy: 60))

        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
