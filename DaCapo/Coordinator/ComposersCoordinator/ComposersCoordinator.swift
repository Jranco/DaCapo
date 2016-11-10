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

    init(window: UIWindow)
    {
        self.window = window
        navigationController = UINavigationController.init()
    }
    
    func start()
    {
        //        let storyboard = UIStoryboard(name: "UserList", bundle: nil)
        
        //        guard let userListTableViewController = (storyboard.instantiateViewControllerWithIdentifier("UserListTableViewController") as? UserListTableViewController) else { return }
        //
        //        let viewModel   = UserListViewModel()
        //        viewModel.model = UserListModel()
        //        viewModel.coordinatorDelegate = self
        //        userListTableViewController.viewModel = viewModel
        //        navigationController.setViewControllers([userListTableViewController], animated: true)
        //        window.rootViewController = navigationController
        
        
        let storyboard = UIStoryboard(name: "Composers", bundle: nil)
        
        guard let composersTableViewController = (storyboard.instantiateViewController(withIdentifier: "ComposersTableViewController") as? ComposersTableViewController) else { return }
        
        let viewModel   = ComposersViewModel()
        viewModel.model = PopularComposersModel()
        viewModel.coordinatorDelegate = self
        composersTableViewController.viewModel = viewModel
        navigationController.setViewControllers([composersTableViewController], animated: true)
        window.rootViewController = navigationController
    }
}

extension ComposersCoordinator: ComposersViewModelCoordinatorDelegate
{
    func showComposerDetails(composer: ComposerVO)
    {
        
    }
}
