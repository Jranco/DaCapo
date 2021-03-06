//
//  SearchComposersModel.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 10/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit
import ObjectMapper

class SearchComposersModel: ComposersModel
{
    // MARK: - Services -
    
    let services = SpotifyServices()
    
    // MARK: - Overriden functions -
    
    override func loadComposers(withOffset offset: Int, withLimit limit: Int, onSuccess: @escaping (_ composers: [ComposerVO]) -> Void, onFailure: @escaping (NSError) -> Void)
    {
        services.searchComposers(withName: composerName!,
                                 withOffset: offset,
                                 withLimit: limit,
                                 onSuccess:
            {
                (data) in
                
                do {
                    let jsonObject  = try JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
                    let jsonArtists = jsonObject["artists"]?["items"] as! NSArray

                    self.composersTotal = jsonObject["artists"]?["total"] as! Int?

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
