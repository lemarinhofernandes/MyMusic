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
        let urlString = Bundle.main.path(forResource: song.trackName, ofType: "mp3")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString else { return }
            
            player = try AVAudioPlayer(contentsOf: URL(string: urlString)!)
            guard let player = player else { return }
            player.play()
        } catch {
            print("error occurred")
        }
        
        //MARK: - Constraints
        [albumImageView, songNameLabel, artistNameLabel, albumNameLabel]
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
                                      y: albumImageView.frame.size.height + 10 + 70 ,
                                      width: holder.frame.size.width-20,
                                      height:  70)
        artistNameLabel.frame = CGRect(x: 10,
                                       y: albumImageView.frame.size.height + 10 + 140,
                                       width: holder.frame.size.width-20,
                                       height: 70)
        songNameLabel.text = song.name
        albumNameLabel.text = song.albumName
        artistNameLabel.text = song.artistName
        
    }
}
