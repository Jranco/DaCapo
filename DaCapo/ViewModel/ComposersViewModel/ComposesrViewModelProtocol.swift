//
//  ComposerViewModelProtocol.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 09/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Foundation
import UIKit

/**
 View delegate
 
 */
protocol ComposersViewModelViewDelegate: class
{
    /**
     This method is invonked in the delegate object conforming to ComposersViewModelViewDelegate protocol, in order to notify the View
     that the image for Composer at indexPath: indexPath is loaded. Then the View can refresh Composers's cell at that given indexPath.
     
     @param imagePath
     */
    func didLoadComposerImageAtIndex(indexPath: NSIndexPath)
}

/**
 Coordinator delegate
 
 */
protocol ComposersViewModelCoordinatorDelegate
{
    /**
     This method invokes a new navigation performed by the conforming to this protocol object, presenting the 'User details' screen.
     
     @param user UserVO object
     */
    func showComposerDetails(composer: ComposerVO)
}

/**
 ComposersViewModelProtocol
 
 */
protocol ComposersViewModelProtocol
{
    /**
     Model
     
     */
    var model: ComposersModelProtocol? { get set }
    
    /**
     A delegate object which conforms to ComposersViewModelCoordinatorDelegate protocol in order to trigger navigation after interaction with View.
     
     */
    var coordinatorDelegate: ComposersViewModelCoordinatorDelegate? { get set }
    
    /**
     A delegate object which conforms to ComposersViewModelViewDelegate protocol in order to update View after Model updates.
     
     */
    var viewDelegate: ComposersViewModelViewDelegate? { get set }
    
    /**
     Screen title
     
     */
    func title(completionBlock: (_ title: String) -> Void)
    
    /**
     The 'composersCount' variable contains the cardinality of current loaded Users in the Model.
     
     */
    var composersCount: Int { get }
    
    /**
     The 'pendingOperations' variable is an instance of 'PendingOperations' class and holds information regarding download progress of Composers' images.
     
     */
    var pendingOperations: PendingOperations { get }
    
    /**
     The 'didLoadAllComposers' variable is a boolean that has value of 'true' if all Composers are fetched from the API, otherwise has 'false'.
     
     */
    var didLoadAllComposers: Bool { get }
    
    /**
     The 'composerAtIndexPath' function fetches and returns a requested Composer's data.
     
     @param  indexPath indexPath of Composer to be fetched.
     @return ComposerVO object, which is the actual Composer data.
     
     */
    func composerAtIndexPath(indexPath: NSIndexPath) -> ComposerVO?
    
    /**
     Returns type of cell, given the indexPath.
     
     @param indexPath IndexPath of Cell.
     @param completionBlock Completion block, passing the cell type as parameter.
     
     */
    //TODO:
    func typeOfCellAtIndexPath(indexPath: NSIndexPath) -> UserListCellType
    
    /**
     Determines if current Composer pool is empty or not.
     
     @return true if user list is empty, false otherwise
     
     */
    func composerListIsEmpty() -> Bool
    
    /**
     Refreshes Composer pool.
     
     @param onSuccess Success completion block.
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func refreshUsers(onSuccess: @escaping () -> Void, onFailure: @escaping (_ error: NSError) -> Void)
    
    /**
     Loades next batch of Composers and appends them in the existing Users pool.
     
     @param onSuccess Success completion block. New composers are loaded at index: newComposerAtIndex and with cardinality: numOfNewComposers
     @param onFailure Failure completion block. Contains an NSError object as parameter.
     
     */
    func loadMoreComposers(onSuccess: @escaping (_ newComposerAtIndex: NSInteger, _ numOfNewComposers: NSInteger) -> Void, onFailure: (_ error: NSError) -> Void)
    
    /**
     Invoke this method from the View in order to present the Composer Details screen.
     
     @param indexPath Indexpath of selected Composer.
     
     */
    func showUserDetailsForComposerAtIndex(indexPath: NSIndexPath)
    
    /**
     Starts async download of Composer's image for the given indexPath.
     
     @param indexPath Indexpath of Composer
     
     */
    func startDownloadImageForComposerAtIndexPath(indexPath: NSIndexPath)
    
    /**
     Starts async download of Composer's images for the given indexPaths of visible rows.
     
     @param indexPath Indexpath of Composer
     
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
