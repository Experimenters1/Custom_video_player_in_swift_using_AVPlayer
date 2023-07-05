//
//  ViewController.swift
//  test2
//
//  Created by huy on 7/5/23.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var CurrentTime: UILabel!
    
    @IBOutlet weak var DurationTime: UILabel!
    
    @IBOutlet weak var sliderTime_test: UISlider!
    
    
    @IBOutlet weak var Mute: UIButton!
    
    @IBOutlet weak var videoView_test: UIView!
    
    @IBOutlet weak var viewMain_test: UIView!
    
    
    
    
    
    @IBOutlet weak var viewPlayerDetails_test: UIView!
    
    // MARK: - Properties
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    private var isVideoPlaying = false
    private var isPlayerViewHide = true
    private var puseTime: CMTime = .zero
    private var timer: Timer?
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView()
        aiv.tintColor = .white
        aiv.color = .white
        aiv.translatesAutoresizingMaskIntoConstraints = false
        return aiv
    }()

    private lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "button")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = false
        button.addTarget(self, action: #selector(onBtnPlay(_:)), for: .touchUpInside)

        return button
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = viewMain_test.bounds
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            self.DurationTime.text = player.currentItem!.duration.durationText
        }
        
        if keyPath == "currentItem.loadedTimeRanges" {
            sliderTime_test.isUserInteractionEnabled = true
            activityIndicatorView.stopAnimating()
            player.play()
        }
    }
    
    // MARK: - Function
    private func setupUI() {
        setupVideoTimeSlider()
        setupPlayer()
    }

    private func setupVideoTimeSlider() {
        let sliderTimeimgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        sliderTimeimgView.image = UIImage(named: "Rectangle 5")
        sliderTime_test.setThumbImage(sliderTimeimgView.image, for: .normal)
        sliderTime_test.setThumbImage(sliderTimeimgView.image, for: .selected)

        sliderTime_test.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        sliderTime_test.isUserInteractionEnabled = false
    }

    private func setupPlayer() {
        activityIndicatorView.startAnimating()
        let urlString =  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
//        URL(string: urlString)  Bundle.main.url(forResource: "free", withExtension: "mp4")
        if let url = Bundle.main.url(forResource: "free", withExtension: "mp4") {
            player = AVPlayer(url: url)
            player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)

            onBtnPlayPause()

            addTimeObserver()
            addObserverToVideoisEnd()

            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            videoView_test.layer.addSublayer(playerLayer)
            setupPlayButtonInsideVideoView()
        }
    }
    
    private func addObserverToVideoisEnd() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerEndPlay), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func addTimeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { [weak self] time in
            guard let currentItem = self!.player.currentItem else {return}
            if self?.player.currentItem!.status == .readyToPlay {
                self?.sliderTime_test.minimumValue = 0
                self?.sliderTime_test.maximumValue = Float(currentItem.duration.seconds)
                self?.sliderTime_test.value = Float(time.seconds)
                self?.CurrentTime.text = time.durationText
            }
        }
    }

    private func setupPlayButtonInsideVideoView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.someAction(_:)))
        self.viewMain_test.addGestureRecognizer(gesture)

        videoView_test.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: videoView_test.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: videoView_test.centerYAnchor).isActive = true

        viewMain_test.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: videoView_test.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: videoView_test.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func onBtnPlayPause() {
        if isVideoPlaying {
            player.pause()
            pausePlayButton.setImage(UIImage(named: "button"), for: .normal)
            isVideoPlaying = false
        } else {
            player.play()
            pausePlayButton.setImage(UIImage(named: "Frame 3"), for: .normal)
            isVideoPlaying = true
        }
        self.hideshowPlayerView()
    }
    
    private func hideshowPlayerView(isViewTouch: Bool = false) {

        if isPlayerViewHide {
            UIView.transition(with: self.viewPlayerDetails_test, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.pausePlayButton.isHidden = false
                           
                
                                self.viewPlayerDetails_test.isHidden = false
                                self.isPlayerViewHide = false
                              })
        } else {
            if isViewTouch {
                UIView.transition(with: self.viewPlayerDetails_test, duration: 0.6,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.pausePlayButton.isHidden = true
                                    
                    
                                    self.viewPlayerDetails_test.isHidden = true
                                    self.isPlayerViewHide = true
                                  })
            }

        }
        self.timer?.invalidate()
        if isPlayerViewHide == false && isVideoPlaying {
            self.timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { [weak self] timer in
                if self?.isPlayerViewHide == false && self!.isVideoPlaying {
                    UIView.transition(with: self!.viewPlayerDetails_test, duration: 0.3,
                                      options: .transitionCrossDissolve,
                                      animations: {
                                        self?.pausePlayButton.isHidden = true
                                        
                        
                                        self?.viewPlayerDetails_test.isHidden = true
                                        self?.isPlayerViewHide = true
                                      })
                }
            }
        }
    }


    @IBAction func sliderValueChange_test(_ sender: UISlider) {
        let seekingCM = CMTimeMake(value: Int64(sender.value * Float(puseTime.timescale)), timescale: puseTime.timescale)
        CurrentTime.text = seekingCM.durationText
        player.seek(to: seekingCM)
    }
    
    
    @IBAction func onBtnMute(_ sender: UIButton) {
        if isPlayerViewHide == false {
            timer?.invalidate()
            hideshowPlayerView()
        }
           Mute.isSelected.toggle()
        if Mute.isSelected {
            Mute.isSelected = true
            player.isMuted = true
        } else {
            Mute.isSelected = false
            player.isMuted = false
        }
    }
    
    
    // MARK: - Event
    @objc private func onBtnPlay(_ sender: Any) {
        onBtnPlayPause()
    }

    @objc private func onSliderValChanged(slider: UISlider, event: UIEvent) {
        self.timer?.invalidate()
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                player.pause()
                guard let currentTime = player.currentItem?.currentTime() else {return}
                self.puseTime = currentTime
            case .moved:
                break
            case .ended:
                if isVideoPlaying {
                    player.play()
                } else {
                    player.pause()
                }
                self.hideshowPlayerView()
            default:
                break
            }
        }

    }

    @objc private func someAction(_ sender: UITapGestureRecognizer) {
        self.hideshowPlayerView(isViewTouch: true)
    }

    @objc private func playerEndPlay() {
        onBtnPlayPause()
        isPlayerViewHide = true
        hideshowPlayerView()
        player.seek(to: CMTime.zero)
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
