//
//  AppCoordinator.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 10/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator
{
    var window: UIWindow
    
    init(window: UIWindow)
    {
        self.window = window
    }
    
    func start()
    {
        showComposers()
    }
    
    func showComposers()
    {
        let composersCoordinator = ComposersCoordinator(window: window)
        composersCoordinator.start()
    }
}
