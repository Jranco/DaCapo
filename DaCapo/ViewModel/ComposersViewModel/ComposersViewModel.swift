//
//  ComposersViewModel.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 10/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

/**
 Types of Cell
 
 */
enum ComposerListCellType {
    
    case Composer
    case LoadMoreComposers
}

class ComposersViewModel: ComposersViewModelProtocol
{
    // MARK: - ComposersViewModelProtocol -
    
    /**
     Model
     
     */
    var currentModel: ComposersModelProtocol?
    
    /**
     Two available models, subclasses of ComposersModel
     The current Model changes dynamically, depending on the current state of the View (search enabled or not).
     
     */
    var popularComposersModel = PopularComposersModel() as PopularComposersModel?
    var searchComposersModel  = SearchComposersModel() as SearchComposersModel?

    /**
     A delegate object which conforms to ComposersViewModelCoordinatorDelegate protocol in order to trigger navigation after interaction with View.
     
     */
    var coordinatorDelegate: ComposersViewModelCoordinatorDelegate?
    
    /**
     A delegate object which conforms to ComposersViewModelViewDelegate protocol in order to update View after Model updates.
     
     */
    var viewDelegate: ComposersViewModelViewDelegate?
    
    /**
     Screen title
     
     */
    func title(completionBlock: (_ title: String) -> Void)
    {
        completionBlock("Composers")
    }
    
    /**
     The 'composersCount' variable contains the cardinality of current loaded Composers in the Model.
     
     */
    var composersCount: Int {
        
        guard currentModel?.composers != nil else { return 0 }
        
        var composersCountTotal = (currentModel?.composers?.count)!
        
        if(didLoadAllComposers() == false)
        {
            composersCountTotal = composersCountTotal + 1
        }
        
        return composersCountTotal
    }

    
    /**
     The 'pendingOperations' variable is an instance of 'PendingOperations' class and holds information regarding download progress of Composers' images.
     
     */
    let pendingOperations = PendingOperations()
    
    /**
     The 'didLoadAllComposers' variable is a boolean that has value of 'true' if all Composers are fetched from the API, otherwise has 'false'.
     
     */
    func didLoadAllComposers() -> Bool
    {

        if(currentModel?.composersTotal == currentModel?.composers?.count)
        {
            return true;
        }
    
        return false;
        
    }
    
    /**
     The 'composerAtIndexPath' function fetches and returns a requested Composer's data.
     
     @param  indexPath indexPath of Composer to be fetched.
     @return ComposerVO object, which is the actual Composer data.
     
     */
    func composerAtIndexPath(indexPath: NSIndexPath) -> ComposerVO?
    {
        let composer = currentModel?.composers![indexPath.row]
        
        return composer
    }
    
    /**
     Returns type of cell, given the indexPath.
     
     @param indexPath IndexPath of Cell.
     @return ComposerListCellType (Composer or LoadMoreComposers)
     
     */
    func typeOfCellAtIndexPath(indexPath: NSIndexPath) -> ComposerListCellType
    {
        if(didLoadAllComposers() == true)
        {
            return ComposerListCellType.Composer
        }
        else
        {
            if(indexPath.row < (self.composersCount) - 1)
            {
                return ComposerListCellType.Composer
            }
            else
            {
                return ComposerListCellType.LoadMoreComposers
            }
        }
    }
    
    /**
     Determines if current Composer pool is empty or not.
     
     @return true if user list is empty, false otherwise
     
     */
    func composerListIsEmpty() -> Bool
    {
        if(self.currentModel!.composers == nil || self.currentModel?.composers?.count == 0)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    /**
     Refreshes Composer pool.
     
     @param onSuccess Success completion block.
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func refreshComposers(onSuccess: @escaping () -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        self.suspendAllImageDownloadingOperations()
        
        currentModel?.reloadComposers(
            onSuccess: {
                
                onSuccess()
                
            }, onFailure:
            {
                
                (error) in
                
                onFailure(error)
                
        })
    }
    
    /**
     Loades next batch of Composers and appends them in the existing Composers pool.
     
     @param onSuccess Success completion block. New composers are loaded at index: newComposerAtIndex and with cardinality: numOfNewComposers
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func loadMoreComposers(onSuccess: @escaping (_ newComposerAtIndex: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        currentModel?.loadMoreComposers(onSuccess:
        {
            (newComposerAtIndex, numOfNewComposers) in
            
            onSuccess(newComposerAtIndex, numOfNewComposers)
            
        }, onFailure:
        {
            (error) in
            
            onFailure(error)
        })
    }
    
    /**
     Searches for a composer for the given name.
     It sets the Model to 'SearchComposersModel' in order to perform a search and change the datasource using the existing Views.
     
     @param name Composer's name
     
     */
    func searchComposers(withName name: String)
    {
        currentModel = SearchComposersModel()
        currentModel?.composerName = name
    }
    
    /**
     Cancels searching for a composer.
     It sets the Model back to the default 'PopularComposersModel' in order to change to the default datasource and show the most popular composers.
     
     */
    func cancelSearchComposers()
    {
        currentModel = popularComposersModel
    }
    
    /**
     Invoke this method from the View in order to present the Composer's 'relative tracks' screen.
     
     @param indexPath Indexpath of selected Composer.
     
     */
    func showRelativeTracksForComposerAtIndex(indexPath: NSIndexPath)
    {
        let selectedComposer = currentModel?.composers?[indexPath.row]
        coordinatorDelegate?.showRelativeTracks(forComposer: selectedComposer!)
    }
    
    /**
     Starts async download of Composer's image for the given indexPath.
     
     @param indexPath Indexpath of Composer
     
     */
    func startDownloadImageForComposerAtIndexPath(indexPath: NSIndexPath)
    {
        guard indexPath.row <= (currentModel?.composers?.count)! - 1 else { return }
        
        let composer = currentModel?.composers![indexPath.row]
        
        guard composer!.mainImage == nil else { return }
        
        startImageDownloadForRecord(for: composer!, indexPath: indexPath)
    }
    
    /**
     Starts async download of Composer's images for the given indexPaths of visible rows.
     
     @param indexPath Indexpath of Composer
     
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
            self.startDownloadImageForComposerAtIndexPath(indexPath: indexPath)
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
    
    func startImageDownloadForRecord(for record: ImageDownloadProtocol, indexPath: NSIndexPath)
    {
        guard pendingOperations.downloadsInProgress[indexPath] == nil else { return }
        
        let downloader = ImageDownloader(obj: record)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.viewDelegate?.didLoadComposerImageAtIndex(indexPath: indexPath)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }

}
