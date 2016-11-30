//
//  Constants.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 08/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation
import UIKit

struct Constants
{
    struct Colors
    {
        static let navigationBarTintColor = UIColor.init(red: 5.0/255.0, green: 5.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        static let navigationTintColor    = UIColor.white
    }
    
    struct YoutubeServices
    {
        static let API_KEY = "YOUR_API_KEY" as String
    }
    
    struct SpotifyServices
    {
    }
    
    struct AsyncImageDownloader
    {
        static let MaxConcurrentImageDownloadOperationCount = 4 as Int
    }
    
    struct ComposerTableViewController
    {
        static let ComposerListTableViewCellHeight    = 70 as CGFloat
    }
    
    struct ComposerTracksViewController
    {
        static let ComposerTracksTableViewCellHeight  = 140 as CGFloat
    }
    
    struct PopularComposersModel
    {
        static let PopularComposersDefaultBatchLimit  =  30 as Int
    }
}
