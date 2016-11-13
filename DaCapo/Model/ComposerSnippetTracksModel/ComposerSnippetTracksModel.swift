//
//  ComposerSnippetTrackModel.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 11/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit
import ObjectMapper

class ComposerSnippetTracksModel: ComposerSnippetTracksModelProtocol
{
    // MARK: - Properties -

    var composer: ComposerProtocol?
    var snippetTracksTotal: Int? = 0
    var nextPageToken: String?
    
    // MARK: - Services -
    
    let services = YoutubeServices()
    
    // MARK: - LifeCycle -
    
    init ()
    {
    }
    
    convenience required init(withComposer composer: ComposerProtocol)
    {
        self.init()
        
        self.composer = composer

    }
    
    // MARK: - PopularComposersModelProtocol -
    
    var snippetTracks: [ComposerSnippetTrackVO]?
    
    func reloadSnippetTracks(onSuccess: @escaping () -> Void, onFailure: @escaping (NSError) -> Void)
    {
        self.loadSnippetTracks(forArtist: (composer?.name!)!,
                           withPageToken: "",
                               withLimit: 30,
                               onSuccess:
        {
            (composerSnippetTracks) in
            
            self.snippetTracks?.removeAll()
            self.snippetTracks = composerSnippetTracks
            
            onSuccess()
        })
        {
            (error) in
            
            onFailure(error)
        }
    }
    
    func loadMoreSnippetTracks(onSuccess: @escaping (_ newSnippetTracks: NSInteger, _ numOfNewSnippetTracks: NSInteger) -> Void, onFailure: @escaping (NSError) -> Void)
    {
        self.loadSnippetTracks(forArtist: (composer?.name!)!,
                           withPageToken: self.nextPageToken!,
                               withLimit: 30,
                               onSuccess:
            {
                (composerSnippetTracks) in
                
                self.snippetTracks?.append(contentsOf: composerSnippetTracks)
                
                onSuccess(0, composerSnippetTracks.count)
            })
        {
            (error) in
            
            onFailure(error)
        }
    }
    
    func loadSnippetTracks(forArtist artist: String, withPageToken pageToken: String, withLimit limit: Int, onSuccess: @escaping (_ composerSnippetTracks: [ComposerSnippetTrackVO]) -> Void, onFailure: @escaping (NSError) -> Void)
    {
        services.searchRelevantSnippetTracks(forArtist: artist,
                                             withPageToken: pageToken,
                                             withLimit: limit,
                                             onSuccess: {
                                                
            (data) in
                                                            
            do {
                let jsonObject        = try JSONSerialization.jsonObject(with: data) as! [String: AnyObject]
                let jsonSnippetTracks = jsonObject["items"] as! NSArray
                
                self.snippetTracksTotal = jsonObject["pageInfo"]?["totalResults"] as! Int?
                self.nextPageToken      = jsonObject["nextPageToken"] as! String?
                
                let composers = NSMutableArray()
                
                for jsonSnippet in jsonSnippetTracks as! [[String:Any]]
                {
                    let composerVO = Mapper<ComposerSnippetTrackVO>().map(JSON: jsonSnippet)! as ComposerSnippetTrackVO
                    composers.add(composerVO)
                }
                
                onSuccess(composers.copy() as! [ComposerSnippetTrackVO])
                
            } catch {
                onFailure(error as NSError)
            }
                                                
        })
        {
            (error) in
                
        }
    }

    
}
