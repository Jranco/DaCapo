//
//  SpotifyServices.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 08/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation
import Alamofire

/**
 Spotify API routes
 
 */
enum SpotifyAPIRoute : Int {
    
    case search
}

enum SpotifyQueryParamType : String {
    
    case album    = "album"
    case artist   = "artist"
    case playlist = "playlist"
    case track    = "track"
}

class SpotifyServices: NSObject
{
//    func searchComposer
    
    func popularComposers(withOffset offset: Int, withLimit limit: Int, onSuccess: @escaping (_ data: Data) -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        artists(withPopularity: 100, forArtist: "\"\"", forGenre: "Classical", withOffset: offset, withLimit: limit, onSuccess:
        {
            (response) in
            
            onSuccess(response)
        })
        {
            (error) in
            
            onFailure(error)
        }
    }
    
    func searchComposers(withName name: String, withOffset offset: Int, withLimit limit: Int, onSuccess: @escaping (_ data: Data) -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        artists(withPopularity: 100, forArtist: name, forGenre: "Classical", withOffset: offset, withLimit: limit, onSuccess:
            {
                (response) in
                
                onSuccess(response)
            })
        {
            (error) in
            
            onFailure(error)
        }
    }
    
    func artists(withPopularity popularity: Int, forArtist artist:String, forGenre genre: String, withOffset offset: Int, withLimit limit: Int, onSuccess: @escaping (_ data: Data) -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        let artistsUrl = self.urlArtists(withPopularity: 100,
                                              forArtist: artist,
                                               forGenre: "classical",
                                             withOffset: offset,
                                              withLimit: limit)
        
        Alamofire.request(artistsUrl.absoluteString, method: .get, parameters: nil)
            
            .responseJSON {
                
                response in
                
                let error: NSError? = response.result.error as NSError?
                
                switch response.result
                {
                case .success( _):
                    
                    let retrievedData  = response.data
                    
                    guard retrievedData != nil else { return }
                    
                    onSuccess(retrievedData!)
                    
                case .failure( _):
                    
                    onFailure(error!)
                    
                }
        }
    }
    
    // MARK: - URL builder -
    
    func urlArtists(withPopularity popularity: Int, forArtist artist:String, forGenre genre: String, withOffset offset: Int, withLimit limit: Int) -> URL
    {
        let urlComponents = self.urlComponent(forRoute: SpotifyAPIRoute.search)

        let popularity = NSURLQueryItem(name: "popularity", value: String(format: "%d", popularity))
        let q          = NSURLQueryItem(name: "q", value: String(format: "artist:%@ genre:%@", artist, genre))
        let type       = NSURLQueryItem(name: "type", value: SpotifyQueryParamType.artist.rawValue)
        let offset     = NSURLQueryItem(name: "offset", value: String(format: "%d", offset))
        let limit      = NSURLQueryItem(name: "limit", value: String(format: "%d", limit))

        urlComponents.queryItems = [q          as URLQueryItem,
                                    type       as URLQueryItem,
                                    popularity as URLQueryItem,
                                    offset     as URLQueryItem,
                                    limit      as URLQueryItem]
        
        return urlComponents.url!
    }
    

    // MARK: - NSURLComponents builder -
    
    func urlComponent(forRoute route: SpotifyAPIRoute) -> NSURLComponents
    {
        let urlComponents = NSURLComponents.init()
        
        urlComponents.scheme = "https"
        urlComponents.host   = "api.spotify.com"
        
        switch route
        {
        case .search:
            
            urlComponents.path   = "/v1/search"
            
            break
        }
        
        return urlComponents
    }
}
