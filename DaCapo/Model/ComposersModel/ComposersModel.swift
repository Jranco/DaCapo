//
//  ComposersModel.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 10/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class ComposersModel: ComposersModelProtocol
{
    var composerName: String? = ""

    // MARK: - PopularComposersModelProtocol -
    
    var composers: [ComposerVO]?
    
    func reloadComposers(onSuccess: @escaping () -> Void, onFailure: @escaping (NSError) -> Void)
    {
        self.loadComposers(withOffset: 0,
                           withLimit: Constants.PopularComposersModel.PopularComposersDefaultBatchLimit,
                           onSuccess:
            
            {
                
                (composers) in
                
                self.composers?.removeAll()
                self.composers = composers
                
                onSuccess()
            })
        {
            (error) in
            
            onFailure(error)
        }
    }
    
    func loadMoreComposers(onSuccess: @escaping (_ newComposer: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: @escaping (NSError) -> Void)
    {
        let offset = composers?.count
        
        guard offset != nil && offset! > 0 else { return }
        
        self.loadComposers(withOffset: offset!,
                           withLimit: Constants.PopularComposersModel.PopularComposersDefaultBatchLimit,
                           onSuccess:
            
            {
                
                (composers) in
                
                self.composers?.append(contentsOf: composers)
                onSuccess(offset!, composers.count)
            })
        {
            (error) in
            
            onFailure(error)
        }
    }
    
    func loadComposers(withOffset offset: Int, withLimit limit: Int, onSuccess: @escaping (_ composers: [ComposerVO]) -> Void, onFailure: @escaping (NSError) -> Void)
    {
    }

}
