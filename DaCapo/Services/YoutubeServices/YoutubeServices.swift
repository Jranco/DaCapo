//
//  YoutubeServices.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 11/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation
import Alamofire

/**
 Youtube API routes
 
 */
enum YoutubeAPIRoute : String {
    
    case search = "/youtube/v3/search"
}

enum YoutubeyQueryParamOrder : String {
    
    case date       = "date"
    case rating     = "rating"
    case relevance  = "relevance"
    case title      = "title"
    case videoCount = "videoCount"
    case viewCount  = "viewCount"

}

class YoutubeServices: NSObject
{
    func searchRelevantSnippetTracks(forArtist artist: String, withPageToken pageToken: String, withLimit limit: Int, onSuccess: @escaping (_ data: Data) -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        let snippetTrackUrl = self.urlSnippetTrack(withQuery: artist,
                                                   withOrder: YoutubeyQueryParamOrder.relevance.rawValue,
                                                   withPageToken: pageToken,
                                                   withLimit: limit)
        
        Alamofire.request(snippetTrackUrl.absoluteString, method: .get, parameters: nil)
            
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
    
    func urlSnippetTrack(withQuery query: String, withOrder order: String, withPageToken pageToken: String, withLimit limit: Int) -> URL
    {
        let urlComponents = self.urlComponent(forRoute: YoutubeAPIRoute.search)

        var token = pageToken

        if(pageToken == "")
        {
            token = "\"\""
        }
        
        let q          = NSURLQueryItem(name: "q", value: query)
        let part       = NSURLQueryItem(name: "part", value: "snippet")
        let maxResults = NSURLQueryItem(name: "maxResults", value: String(format: "%d", limit))
        let pageToken  = NSURLQueryItem(name: "pageToken", value: token)
        let order      = NSURLQueryItem(name: "order", value: order)
        let key        = NSURLQueryItem(name: "key", value: "AIzaSyCjMasplfcJ5e7RO4Yf9haDKr3Tmgf1l0w")
        
        urlComponents.queryItems = [q          as URLQueryItem,
                                    part       as URLQueryItem,
                                    maxResults as URLQueryItem,
                                    pageToken  as URLQueryItem,
                                    order      as URLQueryItem,
                                    key        as URLQueryItem]
        
        return urlComponents.url!
    }
    
    // MARK: - NSURLComponents builder -
    
    func urlComponent(forRoute route: YoutubeAPIRoute) -> NSURLComponents
    {
        let urlComponents = NSURLComponents.init()
        
        urlComponents.scheme = "https"
        urlComponents.host   = "www.googleapis.com"
        
        switch route
        {
        case .search:
            
            urlComponents.path = YoutubeAPIRoute.search.rawValue
            
            break
        }
        
        return urlComponents
    }

}
