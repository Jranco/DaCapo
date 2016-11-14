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
    // MARK: - Subviews -
    
    var playerView: PlayerView?
    
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
        
        playerView?.frame = CGRect.init(x: 0, y: 20, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 20)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Start Player -
    
    func doStartVideo(forComposer composer: ComposerProtocol, forTrack track: ComposerSnippetTrackProtocol)
    {
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



