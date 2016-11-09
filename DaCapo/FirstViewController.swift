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
        
        let spotifyServices = SpotifyServices()
        
        let url = spotifyServices.urlArtists(withPopularity: 100, forGenre: "classical", withOffset: 0, withLimit: 30)
        
//        spotifyServices.artists(withPopularity: 100, forGenre: "Classical", withOffset: 0, withLimit: 30, onSuccess:
//        {
//            (response) in
//            
//            print("response: %@", response)
//            
//            })
//        {
//            (error) in
//            
//            print("error: %@", error.localizedDescription)
//            
//        }
        
        let model = PopularComposersModel()
        
        model.loadComposers(withOffset: 0, withLimit: 20,
                            onSuccess: { (offset, limit) in
                                
            }) { (error) in
                
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

