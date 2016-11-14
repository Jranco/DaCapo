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
    var imageDownloadObj: ImageDownloadProtocol
    
    init(obj: ImageDownloadProtocol)
    {
        self.imageDownloadObj = obj
    }
    
    override func main()
    {
        if self.isCancelled
        {
            return
        }
        
        if(self.imageDownloadObj.mainImageURL == nil)
        {
            
        }
        guard (self.imageDownloadObj.mainImageURL != nil) else {
            return
        }
        
        let imageData = NSData(contentsOf: NSURL.init(string: self.imageDownloadObj.mainImageURL!)! as URL)
        
        if self.isCancelled
        {
            return
        }
        
        if (imageData != nil) && (imageData?.length)! > 0 {
            self.imageDownloadObj.mainImage = UIImage(data:imageData! as Data)
        }
    }
}
