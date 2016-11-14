//
//  ComposerSnippetTracksViewModelProtocol.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation
import UIKit

/**
 View delegate
 
 */
protocol ComposerSnippetTracksViewModelViewDelegate: class
{
    /**
     This method is invonked in the delegate object conforming to ComposerSnippetTracksViewModelViewDelegate protocol, in order to notify the View
     that the image for Composer at indexPath: indexPath is loaded. Then the View can refresh Composers's cell at that given indexPath.
     
     @param imagePath
     */
    func didLoadComposerSnippetTrackImageAtIndex(indexPath: NSIndexPath)
}

/**
 Coordinator delegate
 
 */
protocol ComposerSnippetTracksViewModelCoordinatorDelegate
{
    /**
     This method invokes a new navigation performed by the conforming to this protocol object, presenting the 'User details' screen.
     
     @param user UserVO object
     */
    func doStartVideo(forTrack track: ComposerSnippetTrackProtocol)
}

/**
 ComposerSnippetTracksViewModelProtocol
 
 */
protocol ComposerSnippetTracksViewModelProtocol
{
    /**
     Model
     
     */
    var model: ComposerSnippetTracksModel? { get set }
    
    /**
     A delegate object which conforms to ComposersViewModelCoordinatorDelegate protocol in order to trigger navigation after interaction with View.
     
     */
    var coordinatorDelegate: ComposerSnippetTracksViewModelCoordinatorDelegate? { get set }
    
    /**
     A delegate object which conforms to ComposersViewModelViewDelegate protocol in order to update View after Model updates.
     
     */
    var viewDelegate: ComposerSnippetTracksViewModelViewDelegate? { get set }
    
    /**
     Screen title
     
     */
    func title(completionBlock: (_ title: String) -> Void)
    
    /**
     The 'composerSnippetTracksCount' variable contains the cardinality of current loaded Composers in the Model.
     
     */
    var composerSnippetTracksCount: Int { get }
    
    /**
     The 'pendingOperations' variable is an instance of 'PendingOperations' class and holds information regarding download progress of Tracks' images.
     
     */
    var pendingOperations: PendingOperations { get }
    
    /**
     The 'didLoadAllComposers' variable is a boolean that has value of 'true' if all Tracks are fetched from the API, otherwise has 'false'.
     
     */
    func didLoadAllComposerSnippetTracks() -> Bool
    
    /**
     The 'composerSnippetTracksAtIndexPath' function fetches and returns a requested Track's data.
     
     @param  indexPath indexPath of Track to be fetched.
     @return ComposerSnippetTrackVO object, which is the actual Track data.
     
     */
    func composerSnippetTrackAtIndexPath(indexPath: NSIndexPath) -> ComposerSnippetTrackVO?
    
    /**
     Returns type of cell, given the indexPath.
     
     @param indexPath IndexPath of Cell.
     @return ComposerTracksListCellType
     
     */
    func typeOfCellAtIndexPath(indexPath: NSIndexPath) -> ComposerTracksListCellType
    
    /**
     Determines if current Track pool is empty or not.
     
     @return true if user list is empty, false otherwise
     
     */
    func composerSnippetTracksListIsEmpty() -> Bool
    
    /**
     Refreshes Track pool.
     
     @param onSuccess Success completion block.
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func refreshTracks(onSuccess: @escaping () -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    
    /**
     Loades next batch of Tracks and appends them in the existing Tracks pool.
     
     @param onSuccess Success completion block. New tracks are loaded at index: newComposerSnippetTrackAtIndex and with cardinality: numOfNewComposerSnippetTracks
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func loadMoreComposerSnippetTracks(onSuccess: @escaping (_ newComposerSnippetTrackAtIndex: NSInteger, _ numOfNewComposerSnippetTracks: NSInteger) -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    
    /**
     Invoke this method from the View in order to play the Track
     
     @param indexPath Indexpath of selected Track.
     
     */
    func didSelectTrackAtIndex(indexPath: NSIndexPath)
    
    /**
     Starts async download of Tracks's image for the given indexPath.
     
     @param indexPath Indexpath of Track
     
     */
    func startDownloadImageForComposerSnippetTrackAtIndexPath(indexPath: NSIndexPath)
    
    /**
     Starts async download of Tracks' images for the given indexPaths of visible rows.
     
     @param indexPath Indexpath of Track
     
     */
    func loadImagesForOnscreenCells(pathsArray: [NSIndexPath])
    
    /**
     Suspends all image downloading operations.
     
     */
    func suspendAllImageDownloadingOperations()
    
    /**
     Resumes all image downloading operations.
     
     */
    func resumeAllImageDownloadingOperations()
}
