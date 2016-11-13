//
//  ContainerViewController.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

enum ContainerState : Int {
    
    case none = 1
    case isPlayingMinimizedVideo
    case isPlayingFullscreenVideo
}

class ContainerViewController: UIViewController
{
    // MARK: - Player subviews -
    
    var minimizedPlayerView: MinimizedPlayerView?
    var playerView: YTPlayerView?
    var minimizePlayerButton: UIButton?
    
    // MARK: - ContainerState -
    
    var state = ContainerState.none
    
    // MARK: - Player Datasource -
    
    var composer: ComposerProtocol?
    var track: ComposerSnippetTrackProtocol?
    
    // MARK: - Gestures -
    
    let gestureMinimizedPlayerView = UITapGestureRecognizer(target: self, action: #selector (onEnlargeVideo (_:)))
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        playerView = YTPlayerView.init(frame: view.bounds)
        playerView?.delegate = self
        
        minimizedPlayerView = MinimizedPlayerView.instanceFromNib() as? MinimizedPlayerView
        
        minimizePlayerButton = UIButton.init(frame: CGRect.init(x: 20, y: 74, width: 70, height: 21))
        minimizePlayerButton?.backgroundColor = UIColor.red
        minimizePlayerButton?.titleLabel?.text = "Dismiss"
        minimizePlayerButton?.addTarget(self, action: #selector (onDismissPlayer (_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        minimizedPlayerView?.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.height - 50, width: UIScreen.main.bounds.width, height: 50)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func doStartVideo(forComposer composer: ComposerProtocol, forTrack track: ComposerSnippetTrackProtocol)
    {
        self.composer = composer
        self.track    = track
        
        state = ContainerState.isPlayingMinimizedVideo

        view.addSubview(playerView!)

        playerView?.load(withVideoId: track.videoId)
        playerView?.isHidden = true
        
        view.addSubview(minimizedPlayerView!)
        minimizedPlayerView?.addGestureRecognizer(gestureMinimizedPlayerView)
        minimizedPlayerView?.delegate = self
        minimizedPlayerView?.isHidden = false
        minimizedPlayerView?.composerLabel.text = composer.name
        minimizedPlayerView?.trackDescriptionLabel.text = track.title
        
        view.addSubview(minimizePlayerButton!)
        minimizePlayerButton?.isHidden = true
    }
    
    func stopVideo()
    {
        
    }
    
    func doMinimizeVideo()
    {
        state = ContainerState.isPlayingMinimizedVideo
        
        minimizedPlayerView?.isHidden = false
        minimizedPlayerView?.addGestureRecognizer(gestureMinimizedPlayerView)
        
        minimizePlayerButton?.isHidden = true

        playerView?.isHidden          = true
    }
    
    func doEnlargeVideo()
    {
//        state = ContainerState.isPlayingFullscreenVideo
//        
//        minimizedPlayerView?.isHidden = true
//        playerView?.isHidden          = false
        
        state = ContainerState.isPlayingMinimizedVideo
        
        minimizedPlayerView?.isHidden = true
        minimizePlayerButton?.isHidden = false
        playerView?.isHidden          = false
    }

    func onEnlargeVideo(_ sender:UITapGestureRecognizer)
    {
        doEnlargeVideo()
    }
    
    func onDismissPlayer(_ sender:UITapGestureRecognizer)
    {
        doMinimizeVideo()
    }
}

// MARK: - YTPlayerViewDelegate -

extension ContainerViewController: YTPlayerViewDelegate
{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView!)
    {
        playerView.playVideo()
    }
    
    func playerView(_ playerView: YTPlayerView!, didChangeTo state: YTPlayerState)
    {
        if(state == YTPlayerState.playing)
        {
            if self.state == ContainerState.isPlayingMinimizedVideo
            {
                playerView.isHidden = true
            }

        }
    }
    
    func playerView(_ playerView: YTPlayerView!, didChangeTo quality: YTPlaybackQuality)
    {
        
    }
}

// MARK: - MinimizedPlayerViewDelegate -

extension ContainerViewController: MinimizedPlayerViewDelegate
{
    func didPressEnlarge()
    {
        doEnlargeVideo()
    }
}
