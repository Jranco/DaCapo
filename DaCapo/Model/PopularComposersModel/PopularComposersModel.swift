//
//  PopularComposersModel.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 09/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class PopularComposersModel: PopularComposersModelProtocol
{
    // MARK: - Services -

    let services = SpotifyServices()
    
    // MARK: - PopularComposersModelProtocol -

    var composers: [ComposerVO]?
    
    func reloadComposers(onSuccess: () -> Void, onFailure: (NSError) -> Void)
    {
//        self.loadComposers(withOffset: 0,
//                           withLimit: Constants.PopularComposersModel.PopularComposersDefaultBatchLimit,
//                           onSuccess:
//        {
//            (<#NSInteger#>, <#NSInteger#>) in
//            
//            
//        })
//        {
//            (<#NSError#>) in
//            
//            
//        }
    }
    
    func loadMoreComposers(onSuccess: (_ newComposer: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: (NSError) -> Void)
    {

    }
    
    func loadComposers(withOffset offset: Int, withLimit limit: Int, onSuccess: (_ newComposer: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: (NSError) -> Void)
    {
        services.popularComposers(withOffset: offset,
                                   withLimit: limit,
                                   onSuccess:
        {
                                    
            (composers) in
                                    
                                    
        })
        {
            
            (error) in
            
        }
    }
}
