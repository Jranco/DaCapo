//
//  ComposerSnippetTracksViewModel.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

/**
 Types of Cell
 
 */
enum ComposerTracksListCellType {
    
    case Track
    case LoadMoreTracks
}

class ComposerSnippetTracksViewModel: ComposerSnippetTracksViewModelProtocol
{
    /**
     Model
     
     */
    var model: ComposerSnippetTracksModel?
    
    /**
     A delegate object which conforms to ComposersViewModelCoordinatorDelegate protocol in order to trigger navigation after interaction with View.
     
     */
    var coordinatorDelegate: ComposerSnippetTracksViewModelCoordinatorDelegate?
    
    /**
     A delegate object which conforms to ComposersViewModelViewDelegate protocol in order to update View after Model updates.
     
     */
    var viewDelegate: ComposerSnippetTracksViewModelViewDelegate? 
    
    /**
     Screen title
     
     */
    func title(completionBlock: (_ title: String) -> Void)
    {
        guard model?.composer?.name != nil else {
            
            completionBlock("Tracks")
            return
        }
        
        completionBlock((model?.composer?.name)!)
    }
    
    /**
     The 'composerSnippetTracksCount' variable contains the cardinality of current loaded Composers in the Model.
     
     */
    var composerSnippetTracksCount: Int
    {
        guard model?.snippetTracks != nil else { return 0 }
        
        var snippetTracksCountTotal = (model?.snippetTracks?.count)!
        
        if(didLoadAllComposerSnippetTracks() == false)
        {
            snippetTracksCountTotal = snippetTracksCountTotal + 1
        }
        
        return snippetTracksCountTotal
    }
    
    /**
     The 'pendingOperations' variable is an instance of 'PendingOperations' class and holds information regarding download progress of Composers' images.
     
     */
    var pendingOperations = PendingOperations()
    
    /**
     The 'didLoadAllComposers' variable is a boolean that has value of 'true' if all Composers are fetched from the API, otherwise has 'false'.
     
     */
    func didLoadAllComposerSnippetTracks() -> Bool
    {
        if(model?.snippetTracksTotal == model?.snippetTracks?.count)
        {
            return true;
        }
        
        return false;
    }
    
    /**
     The 'composerSnippetTrackAtIndexPath' function fetches and returns a requested Track's data.
     
     @param  indexPath indexPath of Track to be fetched.
     @return ComposerSnippetTrackVO object, which is the actual Track data.
     
     */
    func composerSnippetTrackAtIndexPath(indexPath: NSIndexPath) -> ComposerSnippetTrackVO?
    {
        let snippetTrack = model?.snippetTracks![indexPath.row]
        
        return snippetTrack
    }
    
    /**
     Returns type of cell, given the indexPath.
     
     @param indexPath IndexPath of Cell.
     @param completionBlock Completion block, passing the cell type as parameter.
     
     */
    //TODO:
    func typeOfCellAtIndexPath(indexPath: NSIndexPath) -> ComposerTracksListCellType
    {
        if(didLoadAllComposerSnippetTracks() == true)
        {
            return ComposerTracksListCellType.Track
        }
        else
        {
            if(indexPath.row < (self.composerSnippetTracksCount) - 1)
            {
                return ComposerTracksListCellType.Track
            }
            else
            {
                return ComposerTracksListCellType.LoadMoreTracks
            }
        }
    }
    
    /**
     Determines if current Composer pool is empty or not.
     
     @return true if user list is empty, false otherwise
     
     */
    func composerSnippetTracksListIsEmpty() -> Bool
    {
        if(self.model!.snippetTracks == nil || self.model?.snippetTracks?.count == 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    /**
     Refreshes Track pool.
     
     @param onSuccess Success completion block.
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func refreshTracks(onSuccess: @escaping () -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        self.suspendAllImageDownloadingOperations()
        
        model?.reloadSnippetTracks(
            onSuccess: { 
                
                onSuccess()

            }, onFailure:
            {
                (error) in
                
                onFailure(error)
        })
    }
    
    /**
     Loades next batch of Tracks and appends them in the existing Tracks pool.
     
     @param onSuccess Success completion block. New tracks are loaded at index: newComposerSnippetTrackAtIndex and with cardinality: numOfNewComposerSnippetTracks
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func loadMoreComposerSnippetTracks(onSuccess: @escaping (_ newComposerSnippetTrackAtIndex: NSInteger, _ numOfNewComposerSnippetTracks: NSInteger) -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        model?.loadMoreSnippetTracks(
            onSuccess:
            {
                (newSnippetTrackAtIndex, numOfNewSnippetTracks) in
                
                onSuccess(newSnippetTrackAtIndex, numOfNewSnippetTracks)

            }, onFailure:
            {
                (error) in
                
                onFailure(error)
        })
    }
    
    /**
     Invoke this method from the View in order to play the Track
     
     @param indexPath Indexpath of selected Track.
     
     */
    func didSelectTrackAtIndex(indexPath: NSIndexPath)
    {
        let snippetTrack = model?.snippetTracks![indexPath.row]

        coordinatorDelegate?.doStartVideo(forTrack: snippetTrack!)
    }
    
    /**
     Starts async download of Tracks's image for the given indexPath.
     
     @param indexPath Indexpath of Track
     
     */
    func startDownloadImageForComposerSnippetTrackAtIndexPath(indexPath: NSIndexPath)
    {
        guard indexPath.row <= (model?.snippetTracks?.count)! - 1 else { return }
        
        let snippetTrack = model?.snippetTracks![indexPath.row]
        
        guard snippetTrack!.mainImageURL != nil else { print("main img url is nil") ;return }
        
        startDownloadForRecord(for: snippetTrack!, indexPath: indexPath)
    }
    
    /**
     Starts async download of Tracks' images for the given indexPaths of visible rows.
     
     @param indexPath Indexpath of Track
     
     */
    func loadImagesForOnscreenCells(pathsArray: [NSIndexPath])
    {
        let allPendingOperations = Set(Array(pendingOperations.downloadsInProgress.keys))
        
        var toBeCancelled = allPendingOperations
        let visiblePaths = Set(pathsArray )
        toBeCancelled.subtract(visiblePaths)
        
        var toBeStarted = visiblePaths
        toBeStarted.subtract(allPendingOperations)
        
        for indexPath in toBeCancelled {
            if let pendingDownload = pendingOperations.downloadsInProgress[indexPath] {
                pendingDownload.cancel()
            }
            pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
            
        }
        
        for indexPath in toBeStarted {
            let indexPath = indexPath as NSIndexPath
            self.startDownloadImageForComposerSnippetTrackAtIndexPath(indexPath: indexPath)
        }
    }
    
    /**
     Suspends all image downloading operations.
     
     */
    func suspendAllImageDownloadingOperations()
    {
        pendingOperations.downloadQueue.isSuspended = true
    }
    
    /**
     Resumes all image downloading operations.
     
     */
    func resumeAllImageDownloadingOperations()
    {
        pendingOperations.downloadQueue.isSuspended = false
    }
    
    // MARK: - AsynImageDownload -
    
    func startDownloadForRecord(for snippetTrack: ComposerSnippetTrackVO, indexPath: NSIndexPath)
    {
        guard pendingOperations.downloadsInProgress[indexPath] == nil else { return }
        
        let downloader = ImageDownloader(obj: snippetTrack)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }

            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.viewDelegate?.didLoadComposerSnippetTrackImageAtIndex(indexPath: indexPath)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}
