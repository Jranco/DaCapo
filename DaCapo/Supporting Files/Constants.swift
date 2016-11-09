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
        //        static let darkGreen  = UIColor.init(red: 51.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    }
    
    struct AsyncImageDownloader
    {
        static let MaxConcurrentImageDownloadOperationCount = 8 as Int
    }
    
    struct ComposerListView
    {
        static let ComposerListTableViewCellHeight          = 70 as CGFloat
    }
    
    struct PopularComposersModel
    {
        static let PopularComposersDefaultBatchLimit  =  30 as Int
    }
}
