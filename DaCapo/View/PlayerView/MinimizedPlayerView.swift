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
    // MARK: - Gesture
    
//    let gesture = UITapGestureRecognizer(target: self, action: #selector (didTap (_:)))

    // MARK: - MinimizedPlayerViewDelegate -
    
    var delegate: MinimizedPlayerViewDelegate?
    
    // MARK: - Subviews -
    
    @IBOutlet var composerLabel: UILabel!
    @IBOutlet var trackDescriptionLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!

    // MARK: LifeCycle
    
    class func instanceFromNib() -> UIView
    {
        return UINib(nibName: "MinimizedPlayerView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MinimizedPlayerView
    }
    
    override func didMoveToWindow()
    {
    }
    
    // MARK: - player button interaction -
    
    @IBAction func onPlayerButton(_ sender: AnyObject)
    {
        self.delegate?.didPressEnlarge()
    }
    
    @IBAction func onMaximizeButton(_ sender: AnyObject)
    {
        self.delegate?.didPressEnlarge()
    }
}
