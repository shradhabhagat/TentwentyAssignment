//
//  VideoPlayerViewController.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 24/04/22.
//

import UIKit
import youtube_ios_player_helper
import RxSwift
import RxCocoa

class VideoPlayerViewController: UIViewController, YTPlayerViewDelegate {
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var backBtn: UIButton!
    
    private var youtubeKey: String?
    
    convenience init(youtubeKey: String?) {
        self.init(nibName: nil, bundle: nil)
        self.youtubeKey = youtubeKey
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self
        playerView.backgroundColor = UIColor.black
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let youtubeKey = youtubeKey{
            playerView.load(withVideoId: youtubeKey)
        }
    }
    
    
    @IBAction func didClickGoBack(_ sender: Any) {
        self.playerView.stopVideo()
        self.navigationController?.popViewController(animated: true)
    }
    
    //Delegate methods YTPlayer
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended{
            self.navigationController?.popViewController(animated: true)
        }
    }

}
