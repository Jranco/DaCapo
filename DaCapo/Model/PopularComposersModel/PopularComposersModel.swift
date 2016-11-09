//
//  PopularComposersModel.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 09/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit
import SwiftyJSON
import ObjectMapper

class PopularComposersModel: PopularComposersModelProtocol
{
    // MARK: - Services -

    let services = SpotifyServices()
    
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
        services.popularComposers(withOffset: offset,
                                   withLimit: limit,
                                   onSuccess:
        {
                                    
            (data) in
            
            do {
                let jsonObject  = try JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
                let jsonArtists = jsonObject["artists"]?["items"] as! NSArray
                
                 let composers = NSMutableArray()
                
                for jsonArtist in jsonArtists as! [[String:Any]]
                {
                    let composerVO = Mapper<ComposerVO>().map(JSON: jsonArtist)! as ComposerVO
                    composers.add(composerVO)
                }
                
                onSuccess(composers.copy() as! [ComposerVO])
                
            } catch {
                onFailure(error as NSError)
            }
        })
        {
    
            (error) in
            
            onFailure(error as NSError)
        }
    }
}
