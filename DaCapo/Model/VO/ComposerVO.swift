//
//  ComposerVO.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 08/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation
import ObjectMapper

class ComposerVO: ComposerProtocol, ImageDownloadProtocol, Mappable
{
    //MARK: - ImageDownloadProtocol -
    
    var mainImage: UIImage?
    
    var mainImageURL: String?
        {
        get {
            
            guard images != nil && (images?.count)! > 0 else { return nil }
            
            let imageURL = images?[1]["url"]
            return imageURL as! String?
        }
    }

    // MARK: - ComposerProtocol  -

    var id: String?
    var name: String?
    var images: [AnyObject]?
    
    // MARK: - Mappable -
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        id     <- map["id"]
        name   <- map["name"]
        images <- map["images"]
    }
}
