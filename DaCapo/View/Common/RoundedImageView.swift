//
//  RoundedImageView.swift
//  JRAGithubUsers
//
//  Created by Thomas Segkoulis on 18/06/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

extension UIImageView
{
    func setRoundedCorners()
    {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds      = true
    }
}