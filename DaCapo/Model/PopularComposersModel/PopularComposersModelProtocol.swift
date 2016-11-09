//
//  PopularComposersModelProtocol.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 09/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation

protocol PopularComposersModelProtocol
{
    var composers: [ComposerVO]? {get}
    
    func reloadComposers(onSuccess: () -> Void, onFailure: (NSError) -> Void)

    func loadMoreComposers(onSuccess: (_ newComposer: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: (NSError) -> Void)
    
    func loadComposers(withOffset offset: Int, withLimit limit: Int, onSuccess: (_ newComposer: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: (NSError) -> Void)

}
