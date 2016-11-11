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
enum UserListCellType {
    
    case Composer
    case LoadMoreComposers
}

class ComposersViewModel: ComposersViewModelProtocol
{
    // MARK: - ComposersViewModelProtocol -
    
    /**
     Model
     
     */
    var model: ComposersModelProtocol?
    
    var popularComposersModel = PopularComposersModel()
    var searchComposersModel  = SearchComposersModel()

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
     The 'usersCount' variable contains the cardinality of current loaded Users in the Model.
     
     */
    var composersCount: Int {
        
        guard model?.composers != nil else { return 0 }
        
        var composersCountTotal = (model?.composers?.count)!
        
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

        if(model?.composersTotal == model?.composers?.count)
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
        let composer = model?.composers![indexPath.row]
        
        return composer
    }
    
    /**
     Returns type of cell, given the indexPath.
     
     @param indexPath IndexPath of Cell.
     @param completionBlock Completion block, passing the cell type as parameter.
     
     */
    //TODO:
    func typeOfCellAtIndexPath(indexPath: NSIndexPath) -> UserListCellType
    {
        if(didLoadAllComposers() == true)
        {
            return UserListCellType.Composer
        }
        else
        {
            if(indexPath.row < (self.composersCount) - 1)
            {
                return UserListCellType.Composer
            }
            else
            {
                return UserListCellType.LoadMoreComposers
            }
        }
    }
    
    /**
     Determines if current Composer pool is empty or not.
     
     @return true if user list is empty, false otherwise
     
     */
    func composerListIsEmpty() -> Bool
    {
        if(self.model!.composers == nil || self.model?.composers?.count == 0)
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
    func refreshUsers(onSuccess: @escaping () -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    {
        self.suspendAllImageDownloadingOperations()
        
        model?.reloadComposers(
            onSuccess: {
                
                onSuccess()
                
            }, onFailure:
            {
                
                (error) in
                
                onFailure(error)
                
        })
    }
    
    /**
     Loades next batch of Composers and appends them in the existing Users pool.
     
     @param onSuccess Success completion block. New composers are loaded at index: newComposerAtIndex and with cardinality: numOfNewComposers
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func loadMoreComposers(onSuccess: @escaping (_ newComposerAtIndex: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: (_ error: NSError) -> Void)
    {
        model?.loadMoreComposers(onSuccess:
        {
            (newComposerAtIndex, numOfNewComposers) in
            
            onSuccess(newComposerAtIndex, numOfNewComposers)
            
        }, onFailure:
        {
            (error) in
            
        })
    }
    
    func searchComposers(withName name: String)
    {
        model = SearchComposersModel()
        model?.composerName = name
    }
    
    func cancelSearchComposers()
    {
        
        model = popularComposersModel
        
    }
    
    /**
     Invoke this method from the View in order to present the Composer Details screen.
     
     @param indexPath Indexpath of selected Composer.
     
     */
    func showUserDetailsForComposerAtIndex(indexPath: NSIndexPath)
    {
        
    }
    
    /**
     Starts async download of Composer's image for the given indexPath.
     
     @param indexPath Indexpath of Composer
     
     */
    func startDownloadImageForComposerAtIndexPath(indexPath: NSIndexPath)
    {
        guard indexPath.row <= (model?.composers?.count)! - 1 else { return }
        
        let composer = model?.composers![indexPath.row]
        
        guard composer!.mainImage == nil else { return }
        
        startDownloadForRecord(for: composer!, indexPath: indexPath)
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
    
    func startDownloadForRecord(for composer: ComposerVO, indexPath: NSIndexPath)
    {
        guard pendingOperations.downloadsInProgress[indexPath] == nil else { return }
        
        let downloader = ImageDownloader(composer: composer)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
//            dispatch_async(dispatch_get_main_queue(), {
//                self.pendingOperations.downloadsInProgress.removeValueForKey(indexPath)
//                self.viewDelegate?.didLoadUserImageAtIndex(indexPath)
//            })
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.viewDelegate?.didLoadComposerImageAtIndex(indexPath: indexPath)
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }

}
