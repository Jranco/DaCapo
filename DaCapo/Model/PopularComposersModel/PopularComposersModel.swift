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
                                    
            (data) in
            
            do {
                let jsonObject  = try JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
                let jsonArtists = jsonObject["artists"]?["items"] as! NSArray
                
                for jsonArtist in jsonArtists
                {
//                    let composerVO = Mapper<ComposerVO>().map(jsonArtist as! JSON) as ComposerVO
     
                    let composerVO = Mapper<ComposerVO>().mapDictionary(JSONObject: jsonArtist) as ComposerVO
                    
                    print("composerVO: ", composerVO)

                }
            
                
                print("jsonArtists:", jsonArtists)
            } catch {
                print("json error: \(error.localizedDescription)")
            }
            
//            let jsonObject       = JSON(data: data)
//            let jsonArtists = jsonObject["artists"]["items"]
//            
//            for jsonArtist in jsonArtists.arrayObject!
//            {
////                let composerVO = Mapper<ComposerVO>().map(jsonArtist.) as ComposerVO
// 
//            }
            
        })
        {
            
            (error) in
            
        }
    }
}
