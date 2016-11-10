//
//  AsyncImageDownloader.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 09/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation
import UIKit

class PendingOperations
{
    lazy var downloadsInProgress = [NSIndexPath:Operation]()
    lazy var downloadQueue:OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = Constants.AsyncImageDownloader.MaxConcurrentImageDownloadOperationCount
        return queue
    }()
}

class ImageDownloader: Operation
{
    let composer: ComposerVO
    
    init(composer: ComposerVO)
    {
        self.composer = composer
    }
    
    override func main()
    {
        if self.isCancelled
        {
            return
        }
        
        if(self.composer.mainImageURL == nil)
        {
            
        }
        guard (self.composer.mainImageURL != nil) else {
            return
        }
        
        let imageData = NSData(contentsOf: NSURL.init(string: self.composer.mainImageURL!)! as URL)
        
        if self.isCancelled
        {
            return
        }
        
        if (imageData?.length)! > 0 {
            self.composer.mainImage = UIImage(data:imageData! as Data)
        }
    }
}
