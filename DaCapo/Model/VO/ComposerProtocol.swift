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
    var id: Int? {get}
    var name: String? {get}
    var image: UIImage? { get set }
}
