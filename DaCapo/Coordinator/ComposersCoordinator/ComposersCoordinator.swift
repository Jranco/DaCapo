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
        containerViewController = UIViewController.init()
    }
    
    func start()
    {
        let storyboard = UIStoryboard(name: "Composers", bundle: nil)
        
        guard let composersTableViewController = (storyboard.instantiateViewController(withIdentifier: "ComposersTableViewController") as? ComposersTableViewController) else { return }
        
        let viewModel   = ComposersViewModel()
        viewModel.model = PopularComposersModel()
        viewModel.popularComposersModel = viewModel.model as! PopularComposersModel
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
    func showComposerDetails(composer: ComposerVO)
    {
        
    }
}
