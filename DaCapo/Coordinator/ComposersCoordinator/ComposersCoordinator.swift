//
//  ComposersCoordinator.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 10/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class ComposersCoordinator: Coordinator
{
    var window: UIWindow
    var navigationController: UINavigationController
    var containerViewController: UIViewController

    init(window: UIWindow)
    {
        self.window = window
        navigationController    = UINavigationController.init()
        navigationController.navigationBar.isOpaque     = true
        navigationController.navigationBar.barTintColor = UIColor.init(red: 5.0/255.0, green: 5.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        navigationController.navigationBar.tintColor    = UIColor.white
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        let storyboard = UIStoryboard(name: "Container", bundle: nil)

        containerViewController = (storyboard.instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController)!
    }
    
    func start()
    {
        let storyboard = UIStoryboard(name: "Composers", bundle: nil)
        
        guard let composersTableViewController = (storyboard.instantiateViewController(withIdentifier: "ComposersTableViewController") as? ComposersTableViewController) else { return }
        
        let viewModel   = ComposersViewModel()
        viewModel.currentModel = PopularComposersModel()
        viewModel.popularComposersModel = viewModel.currentModel as! PopularComposersModel
        viewModel.coordinatorDelegate = self
        
        composersTableViewController.viewModel = viewModel
        
        navigationController.setViewControllers([composersTableViewController], animated: true)
        containerViewController.addChildViewController(navigationController)
        containerViewController.view.addSubview(navigationController.view)
        navigationController.view.bounds = containerViewController.view.bounds
        navigationController.didMove(toParentViewController: containerViewController)
        window.rootViewController = containerViewController
    }
}

extension ComposersCoordinator: ComposersViewModelCoordinatorDelegate
{
    func showRelativeTracks(forComposer  composer: ComposerVO)
    {
        let composerTracksCoordinator = ComposerTracksCoordinator.init(window: window, navigationController: navigationController, containerViewController: containerViewController as! ContainerViewController)
        composerTracksCoordinator.composerVO = composer
        
        composerTracksCoordinator.start()
    }
}
