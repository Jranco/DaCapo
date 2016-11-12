//
//  ComposerSnippetTrack.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 11/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit
import ObjectMapper

class ComposerSnippetTrackVO: ComposerSnippetTrackProtocol, ImageDownloadProtocol, Mappable
{
    //MARK: - ImageDownloadProtocol -

    var mainImage: UIImage?
    
    var mainImageURL: String?


    //MARK: - ComposerSnippetTrackProtocol -
    
    var kind: String?
    var etag: String?
    var videoId: String?
    var publishedAt: String?
    var channelId: String?
    var title: String?
    var description: String?
    var channelTitle: String?
    var liveBroadcastContent: String?
    
    // MARK: - Mappable -
    
    required init?(map: Map)
    {
        
    }
    
    func mapping(map: Map)
    {
        kind                 <- map["kind"]
        etag                 <- map["etag"]
        videoId              <- map["id.videoId"]
        publishedAt          <- map["snippet.publishedAt"]
        channelId            <- map["snippet.channelId"]
        title                <- map["snippet.title"]
        description          <- map["snippet.description"]
        mainImageURL            <- map["snippet.thumbnails.high.url"]
        channelTitle         <- map["snippet.channelTitle"]
        liveBroadcastContent <- map["snippet.liveBroadcastContent"]
    }
}
