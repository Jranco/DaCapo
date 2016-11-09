//
//  ComposerVO.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 08/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation
import ObjectMapper

class ComposerVO: ComposerProtocol, Mappable
{
    // MARK: - ComposerProtocol  -

    var id: Int?
    var name: String?
    var image: UIImage?
    
    // MARK: - Mappable -
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        id <- map["id"]
        name <- map["name"]
//        image <- map[]
    }
}
