//
//  ComposerSnippetTrackProtocol.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 11/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

protocol ComposerSnippetTrackProtocol
{
    var kind: String? {get}
    var etag: String? {get}
    var videoId: String? {get}
    var publishedAt: String? {get}
    var channelId: String? {get}
    var title: String? {get}
    var description: String? {get}
    var channelTitle: String? {get}
    var liveBroadcastContent: String? {get}
}
