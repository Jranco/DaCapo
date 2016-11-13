//
//  ComposerTracksViewController.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class ComposerTracksViewController: UIViewController
{
    // MARK: - Subviews -
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var composerImageView: UIImageView!

    var didAppear = false
    
    // MARK: - Constraints/etc -
    
    var initTableViewOffsetY = 0.0 as CGFloat
    
    // MARK: - ViewModel -
    
    var viewModel: ComposerSnippetTracksViewModel?
        {
        willSet{
            
            viewModel?.viewDelegate = nil
            
        }
        
        didSet{
            
            viewModel?.viewDelegate = self
        }
    }

    // MARK: - LifeCycle -

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self

        tableView.registerReusableCell(LoadingMoreUsersTableViewCell.self)
        tableView.registerReusableCell(ComposerTracksTableViewCell.self)

        tableView.tableFooterView = UIView()
        
        self.viewModel?.title(
            completionBlock: {
                (title) in
                
                self.title = title
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if(self.viewModel?.composerSnippetTracksListIsEmpty() == true)
        {
            self.refreshTrackList(sender: self)
        }
        
        composerImageView.image = self.viewModel?.model?.composer?.mainImage
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        composerImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.composerImageView.alpha = 1
        })
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        
        tableView.contentInset = UIEdgeInsetsMake(headerView.frame.size.height, 0, 0, 0)
        initTableViewOffsetY = tableView.contentOffset.y
        composerImageView.setRoundedCorners()
        
        didAppear = true
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - RefreshControl action -
    
    func refreshTrackList(sender:AnyObject)
    {
        self.tableView.isUserInteractionEnabled = false
        
        self.viewModel?.refreshUsers(
            onSuccess: {
                self.tableView.reloadData()
                self.tableView.isUserInteractionEnabled = true
                
                self.tableView.alpha = 0
                
                UIView.animate(withDuration: 0.3,
                               animations: {
                                self.tableView.alpha = 1
                })
                
            }, onFailure:
            {
                (error) in
                
                self.tableView.isUserInteractionEnabled = true
                
        })
    }
    
    // MARK: - UIScrollViewDelegate -
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        let composerImageViewZoomFactor = -(scrollView.contentOffset.y - initTableViewOffsetY)
        
        if(didAppear == true)
        {
            print("asd: %f", composerImageViewZoomFactor)
            if(composerImageViewZoomFactor == 0 || composerImageViewZoomFactor < -150.0)
            {
                composerImageView.transform = CGAffineTransform.identity
            }
            else
            {
                composerImageView.transform = CGAffineTransform(scaleX: 1 + composerImageViewZoomFactor * 0.005, y: 1 + composerImageViewZoomFactor * 0.005)
            }
        }

    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        viewModel?.suspendAllImageDownloadingOperations()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            viewModel?.loadImagesForOnscreenCells(pathsArray: tableView.indexPathsForVisibleRows! as [NSIndexPath])
            viewModel?.resumeAllImageDownloadingOperations()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        viewModel?.loadImagesForOnscreenCells(pathsArray: tableView.indexPathsForVisibleRows! as [NSIndexPath])
        viewModel?.resumeAllImageDownloadingOperations()
    }
}

extension ComposerTracksViewController: UITableViewDataSource
{
    @objc(numberOfSectionsInTableView:) func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (viewModel?.composerSnippetTracksCount)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = self.tableViewCellForIndexPath(indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func tableViewCellForIndexPath(indexPath: NSIndexPath) -> UITableViewCell
    {
        if(viewModel?.typeOfCellAtIndexPath(indexPath: indexPath) == UserListCellType.LoadMoreComposers)
        {
            return loadingMoreUsersTableViewCell(indexPath: indexPath)
        }
        else
        {
            return composerTracksTableViewCell(indexPath: indexPath)
        }
    }
    
    func loadingMoreUsersTableViewCell(indexPath: NSIndexPath) -> LoadingMoreUsersTableViewCell
    {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath as IndexPath) as LoadingMoreUsersTableViewCell
        
        cell.spinner.startAnimating()
        
        self.viewModel?.loadMoreComposerSnippetTracks(
            
            onSuccess:
            {
                
                (newSnippetTrackAtIndex, numOfNewSnippetTracks) in
                
                self.tableView.reloadData()
                
            }, onFailure:
            {
                (error) in
        })
        
        return cell
    }
    
    func composerTracksTableViewCell(indexPath: NSIndexPath) -> ComposerTracksTableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(indexPath: indexPath as IndexPath) as ComposerTracksTableViewCell
        
        let composerTrackData = self.viewModel?.composerSnippetTracksAtIndexPath(indexPath: indexPath)
        
        cell.composerTrackData = composerTrackData
        
        if (!self.tableView.isDragging && !self.tableView.isDecelerating)
        {
            self.viewModel?.startDownloadImageForComposerSnippetTrackAtIndexPath(indexPath: indexPath)
            self.viewModel?.resumeAllImageDownloadingOperations()
        }
        
        return cell
    }
}

extension ComposerTracksViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //        guard tableView.cellForRowAtIndexPath(indexPath)?.isKindOfClass(ComposersTableViewCell) == true else { return }
        //
        //        self.viewModel?.showComposerDetailsForComposerAtIndex(indexPath: indexPath)
  
        self.viewModel?.didSelectTrackAtIndex(indexPath: indexPath as NSIndexPath)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        self.viewModel!.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath as NSIndexPath)
    }
}

// MARK: - UserListViewModelViewDelegate -

extension ComposerTracksViewController: ComposerSnippetTracksViewModelViewDelegate
{
    func didLoadComposerSnippetTrackImageAtIndex(indexPath: NSIndexPath)
    {
        if((self.tableView.indexPathsForVisibleRows?.contains(indexPath as IndexPath))! == true)
        {
            self.tableView.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
    }
}

