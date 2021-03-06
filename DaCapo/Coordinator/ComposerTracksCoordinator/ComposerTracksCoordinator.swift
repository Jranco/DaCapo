//
//  ComposerTracksCoordinator.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class ComposerTracksCoordinator: Coordinator
{
    var window: UIWindow
    var navigationController: UINavigationController
    var containerViewController: ContainerViewController
    var composerVO: ComposerVO?
    
    init(window: UIWindow, navigationController: UINavigationController, containerViewController: ContainerViewController)
    {
        self.window = window
        self.navigationController    = navigationController
        self.containerViewController = containerViewController
    }
    
    func start()
    {
        let storyboard = UIStoryboard(name: "ComposerTracks", bundle: nil)
        
        guard let composersTableViewController = (storyboard.instantiateViewController(withIdentifier: "ComposerTracksViewController") as? ComposerTracksViewController) else { return }
        
        let viewModel   = ComposerSnippetTracksViewModel()
        viewModel.model = ComposerSnippetTracksModel.init(withComposer: composerVO!)
        viewModel.coordinatorDelegate = self
        
        composersTableViewController.viewModel = viewModel
        
        navigationController.pushViewController(composersTableViewController, animated: true)
    }
}

extension ComposerTracksCoordinator: ComposerSnippetTracksViewModelCoordinatorDelegate
{
    func doStartVideo(forTrack track: ComposerSnippetTrackProtocol)
    {
        containerViewController.doStartVideo(forComposer: composerVO!, forTrack: track)
    }
}
