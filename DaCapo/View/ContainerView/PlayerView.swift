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
        doMinimizeVideo(animated: true)

        let playerVars = ["playsinline" : 1]
        
        player.load(withVideoId: track.videoId, playerVars: playerVars)
        player?.isHidden = true
        player.frame = CGRect.zero
        minimizedPlayer?.composerLabel.text         = composer.name
        minimizedPlayer?.trackDescriptionLabel.text = track.title
    }
    
    // MARK: - player button interaction -
    
    @IBAction func onDismissButton(_ sender: AnyObject)
    {
        delegate?.playerDidDismiss()
        doMinimizeVideo(animated: true)
    }
    
    // MARK: - Video Player actions -
    
    func doMinimizeVideo(animated: Bool)
    {
        frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: 55)
        
        topBar.isHidden  = true
        player?.isHidden = true
        
        minimizedPlayer?.frame = bounds
        addSubview(minimizedPlayer!)
        
        if(animated == true)
        {
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
                
                var viewFrame = self.frame
                viewFrame.origin.y -= viewFrame.size.height
                
                self.frame = viewFrame
                
                }, completion: {
                    finished in
            })
        }
        else
        {
            frame.origin.y -= frame.size.height
        }

        
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
        var stateStr = ""
        
        switch state {
        case YTPlayerState.unstarted:
            stateStr = "unstarted"
        case YTPlayerState.ended:
            stateStr = "ended"
        case YTPlayerState.playing:
            stateStr = "playing"
        case YTPlayerState.paused:
            stateStr = "paused"
        case YTPlayerState.buffering:
            stateStr = "buffering"
        case YTPlayerState.queued:
            stateStr = "queued"
        default:
            stateStr = "unknown"
        }
        
        minimizedPlayer?.stateLabel.text = stateStr

        if(state == YTPlayerState.playing)
        {
            doMinimizeVideo(animated: false)
        }
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
