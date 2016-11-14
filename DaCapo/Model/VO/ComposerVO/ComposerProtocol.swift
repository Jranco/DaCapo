//
//  ComposerProtocol.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 08/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

protocol ComposerProtocol
{
    var id: String? {get}
    var name: String? {get}
    var mainImage: UIImage? {get}
    var images: [AnyObject]? { set get }
}
