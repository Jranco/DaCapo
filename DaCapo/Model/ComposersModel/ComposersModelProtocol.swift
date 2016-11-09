//
//  PopularComposersModelProtocol.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 09/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation

protocol ComposersModelProtocol
{
    var composers: [ComposerVO]? {get}
    
    func reloadComposers(onSuccess: @escaping () -> Void, onFailure: @escaping (NSError) -> Void)

    func loadMoreComposers(onSuccess: @escaping (_ newComposer: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: @escaping (NSError) -> Void)
    
    func loadComposers(withOffset offset: Int, withLimit limit: Int, onSuccess: @escaping (_ composers: [ComposerVO]) -> Void, onFailure: @escaping (NSError) -> Void)
}
