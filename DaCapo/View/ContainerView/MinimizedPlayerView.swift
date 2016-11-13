//
//  MinimizedPlayerView.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit


protocol MinimizedPlayerViewDelegate
{
    func didPressEnlarge()
}

class MinimizedPlayerView: UIView
{
    // MARK: - MinimizedPlayerViewDelegate -
    
    var delegate: MinimizedPlayerViewDelegate?
    
    // MARK: - Subviews -
    
    @IBOutlet var composerLabel: UILabel!
    @IBOutlet var trackDescriptionLabel: UILabel!
    @IBOutlet var playerButton: UIButton!
        
    class func instanceFromNib() -> UIView
    {
        return UINib(nibName: "MinimizedPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MinimizedPlayerView
    }
    
    // MARK: - player button interaction -
    
    @IBAction func onPlayerButton(_ sender: AnyObject)
    {
        self.delegate?.didPressEnlarge()
    }
    

}
