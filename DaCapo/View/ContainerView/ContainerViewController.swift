//
//  ContainerViewController.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController
{
    // MARK: - Player subviews -
    
    var playerView: PlayerView?
    
    // MARK: - ContainerState -
    
    // MARK: - Player Datasource -
    
    var composer: ComposerProtocol?
    var track: ComposerSnippetTrackProtocol?
    
    
    // MARK: - LifeCycle -
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        playerView = PlayerView.instanceFromNib() as? PlayerView
        playerView?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        playerView?.frame          = CGRect.init(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 20)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func doStartVideo(forComposer composer: ComposerProtocol, forTrack track: ComposerSnippetTrackProtocol)
    {
        self.composer = composer
        self.track    = track
        
        view.addSubview(playerView!)

        playerView?.loadVideo(forComposer: composer, withTrack: track)
    }
}

// MARK: - PlayerViewDelefate -

extension ContainerViewController: PlayerViewDelegate
{
    func playerDidDismiss()
    {
    }
}



