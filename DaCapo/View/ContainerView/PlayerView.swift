//
//  PlayerView.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 13/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

enum PlayerState : Int {
    
    case none = 1
    case isPlayingMinimizedVideo
    case isPlayingFullscreenVideo
}

protocol PlayerViewDelegate
{
    func playerDidDismiss()
}

class PlayerView: UIView
{
    // MARK: - Player State -
    
    var state = PlayerState.none

    // MARK: - PlayerViewDelegate -
    
    var delegate: PlayerViewDelegate?

    // MARK: - Subviews -

    @IBOutlet var topBar: UIView!
    @IBOutlet var player: YTPlayerView!
    @IBOutlet var minimizedPlayer = MinimizedPlayerView.instanceFromNib() as? MinimizedPlayerView
    
    // MARK: - LifeCycle -
    
    class func instanceFromNib() -> UIView
    {
        return UINib(nibName: "PlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PlayerView
    }
    
    override func awakeFromNib()
    {
//        minimizedPlayer?.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width, height: 50)
//
//        addSubview(minimizedPlayer!)
        
        player.delegate           = self
        minimizedPlayer?.delegate = self
    }
    
    override func didMoveToWindow()
    {
        minimizedPlayer?.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 55)
    }
    
    // MARK: - Video LifeCycle -
    
    func loadVideo(forComposer composer: ComposerProtocol, withTrack track: ComposerSnippetTrackProtocol)
    {
        doMinimizeVideo()

        player.load(withVideoId: track.videoId)
        player?.isHidden = true

        minimizedPlayer?.composerLabel.text         = composer.name
        minimizedPlayer?.trackDescriptionLabel.text = track.title
    }
    
    // MARK: - player button interaction -
    
    @IBAction func onDismissButton(_ sender: AnyObject)
    {
        delegate?.playerDidDismiss()
        doMinimizeVideo()
    }
    
    // MARK: - Video Player actions -
    
    func doMinimizeVideo()
    {
        frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - 55, width: UIScreen.main.bounds.width, height: 55)
        topBar.isHidden = true
        addSubview(minimizedPlayer!)
        
        player?.isHidden = true
    }
    
    func doEnlargeVideo()
    {
        frame = CGRect.init(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-20)

        minimizedPlayer?.removeFromSuperview()
        player?.isHidden          = false
        topBar.isHidden = false
    }
}

// MARK: - YTPlayerViewDelegate -

extension PlayerView: YTPlayerViewDelegate
{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView!)
    {
        player.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView!, didChangeTo state: YTPlayerState)
    {
        
    }
    
    func playerView(_ playerView: YTPlayerView!, didChangeTo quality: YTPlaybackQuality)
    {
        
    }
}

// MARK: - MinimizedPlayerViewDelegate -

extension PlayerView: MinimizedPlayerViewDelegate
{
    func didPressEnlarge()
    {
        doEnlargeVideo()
    }
}
