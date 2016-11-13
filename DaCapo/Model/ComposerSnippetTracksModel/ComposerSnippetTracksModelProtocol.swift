//
//  ComposerSnippetTrackModelProtocol.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation

protocol ComposerSnippetTracksModelProtocol
{
    var composer: ComposerProtocol? {get set}
    var snippetTracksTotal: Int? {get set}
    var nextPageToken: String? {get set}
    
    var snippetTracks: [ComposerSnippetTrackVO]? {get set}

    init(withComposer composer: ComposerProtocol)

    func reloadSnippetTracks(onSuccess: @escaping () -> Void, onFailure: @escaping (NSError) -> Void)
    func loadMoreSnippetTracks(onSuccess: @escaping (_ newSnippetTracks: NSInteger, _ numOfNewSnippetTracks: NSInteger) -> Void, onFailure: @escaping (NSError) -> Void)

    func loadSnippetTracks(forArtist artist: String, withPageToken pageToken: String, withLimit limit: Int, onSuccess: @escaping (_ composerSnippetTracks: [ComposerSnippetTrackVO]) -> Void, onFailure: @escaping (NSError) -> Void)

}

