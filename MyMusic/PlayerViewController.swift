//
//  PlayerViewController.swift
//  MyMusic
//
//  Created by Luís Eduardo Marinho Fernandes on 20/09/23.
//

import AVFoundation
import UIKit

class PlayerViewController: UIViewController {
    //MARK: - Public properties
    public var position: Int = 0
    public var songs: [Song] = []
    //a
    
    //MARK: - Private properties
    private let albumImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private var slider: UISlider = {
        let slider = UISlider()
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlide(_:)), for: .valueChanged)
        return slider
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapPlayStopButton), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Properties
    @IBOutlet var holder: UIView!
    var player: AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let player = player {
            player.stop()
        }
    }
    
    func configure() {
        let song = songs[position]
        
        playSong(song: song)
        setConstraints(song: song)
        
        
    }
}

extension PlayerViewController {
    
    // MARK: - Public methods
    @objc func didSlide(_ slider: UISlider) {
        let value = slider.value
        player?.volume = value
    }
    
    @objc func didTapBackButton() {
        guard let player = player else { return }
        if position > 0 {
            position -= 1
            player.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapNextButton() {
        guard let player = player else { return }
        if position < songs.count  - 1 {
            position += 1
            player.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    
    @objc func didTapPlayStopButton() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.stop()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
            UIView.animate(withDuration: 0.5) {
                self.albumImageView.frame = CGRect(x: 30,
                                                   y: 30,
                                                   width: self.holder.frame.size.width-60,
                                                   height: self.holder.frame.size.height-60)
            }
            return
        }
        player.play()
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.albumImageView.frame = CGRect(x: 10,
                                               y: 10,
                                               width: self.holder.frame.size.width-20,
                                               height: self.holder.frame.size.height-20)
        }
    }
    
    // MARK: - Private methods
    private func setConstraints(song: Song) {
        let yPosition = artistNameLabel.frame.origin.y+70+20
        let size: CGFloat = 70
        
        [albumImageView, songNameLabel, artistNameLabel, albumNameLabel, slider, playPauseButton, nextButton, backButton]
            .forEach { holder.addSubview($0) }
        
        albumImageView.image = UIImage(named: song.imageName)
        albumImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width-20,
                                      height: holder.frame.size.height-20)
        songNameLabel.frame = CGRect(x: 10,
                                     y: albumImageView.frame.size.height + 10,
                                     width: holder.frame.size.width-20,
                                     height: 70)
        albumNameLabel.frame = CGRect(x: 10,
                                      y: albumImageView.frame.size.height - 10 -  70 ,
                                      width: holder.frame.size.width-20,
                                      height:  70)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height + 10 + 140,
                                       width: holder.frame.size.width-20,
                                       height: 70)
        slider.frame = CGRect(x: 20,
                              y: holder.frame.size.height-60,
                              width: holder.frame.size.width-40,
                              height: 50)
        playPauseButton.frame = CGRect(x: (holder.frame.size.width-size)/2.0,
                                       y: yPosition,
                                       width: size,
                                       height: size)
        nextButton.frame = CGRect(x: holder.frame.size.width-size-20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
    }
    
    private func playSong(song: Song) {
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else { return }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            guard let player = player else { return }
            player.volume = 0.5
            player.play()
        } catch {
            print("error occurred")
        }
    }
}
