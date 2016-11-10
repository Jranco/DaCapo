//
//  FirstViewController.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 08/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        let storyboard = UIStoryboard(name: "Composers", bundle: nil)
        
        guard let composersTableViewController = (storyboard.instantiateViewController(withIdentifier: "ComposersTableViewController") as? ComposersTableViewController) else { return }
        
        let viewModel   = ComposersViewModel()
        viewModel.model = PopularComposersModel()
        composersTableViewController.viewModel = viewModel
        
        self.present(composersTableViewController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

