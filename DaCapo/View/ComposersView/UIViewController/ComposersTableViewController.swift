//
//  ComposersTableViewController.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 10/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit

class ComposersTableViewController: UITableViewController
{
    // MARK: - ViewModel -
    
    var viewModel: ComposersViewModel?
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
        
        self.tableView.registerReusableCell(ComposersTableViewCell.self)
        self.tableView.registerReusableCell(LoadingMoreUsersTableViewCell.self)
        
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
        
        if(self.viewModel?.composerListIsEmpty() == true)
        {
            self.refreshUserList(sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if(refreshControl == nil)
        {
            // Should be moved to ViewDidLoad, but there is a problem with the table offset
            refreshControl = UIRefreshControl()
            refreshControl!.attributedTitle = NSAttributedString(string: NSLocalizedString("kPullToRefresh", comment: ""))
//            refreshControl!.addTarget(self, action: #selector(ComposersTableViewController.refreshUserList(_:)), for: UIControlEvents.ValueChanged)
        }
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableViewDatasource -
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (viewModel?.composersCount)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
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
            return composersTableViewCell(indexPath: indexPath)
        }
    }
    
    func loadingMoreUsersTableViewCell(indexPath: NSIndexPath) -> LoadingMoreUsersTableViewCell
    {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath as IndexPath) as LoadingMoreUsersTableViewCell
        
        cell.spinner.startAnimating()
        
        self.viewModel?.loadMoreComposers(onSuccess:
        {
            (newComposerAtIndex, numOfNewComposers) in
            
            self.tableView.reloadData()

        }, onFailure:
        {
            (error) in
            
        })
        
        return cell
    }
    
    func composersTableViewCell(indexPath: NSIndexPath) -> ComposersTableViewCell
    {
        let cell = self.tableView.dequeueReusableCell(indexPath: indexPath as IndexPath) as ComposersTableViewCell
        
        let composerData = self.viewModel?.composerAtIndexPath(indexPath: indexPath)
        
        cell.composerData = composerData
        
        if (!self.tableView.isDragging && !self.tableView.isDecelerating)
        {
            self.viewModel?.startDownloadImageForComposerAtIndexPath(indexPath: indexPath)
            self.viewModel?.resumeAllImageDownloadingOperations()
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate -
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return Constants.ComposerListView.ComposerListTableViewCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
//        guard tableView.cellForRowAtIndexPath(indexPath)?.isKindOfClass(ComposersTableViewCell) == true else { return }
//
//        self.viewModel?.showComposerDetailsForComposerAtIndex(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        self.viewModel!.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath as NSIndexPath)
    }
    
    // MARK: - RefreshControl action -
    
    func refreshUserList(sender:AnyObject)
    {
        self.tableView.isUserInteractionEnabled = false
        
        self.viewModel?.refreshUsers(
            onSuccess: {
                self.tableView.reloadData()
//                self.refreshControl!.endRefreshing()
                self.tableView.isUserInteractionEnabled = true
                
            }, onFailure:
            {
                (error) in
                
                self.tableView.isUserInteractionEnabled = true
                
        })
    }
    
    // MARK: - UIScrollViewDelegate -
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        viewModel?.suspendAllImageDownloadingOperations()
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            viewModel?.loadImagesForOnscreenCells(pathsArray: tableView.indexPathsForVisibleRows! as [NSIndexPath])
            viewModel?.resumeAllImageDownloadingOperations()
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        viewModel?.loadImagesForOnscreenCells(pathsArray: tableView.indexPathsForVisibleRows! as [NSIndexPath])
        viewModel?.resumeAllImageDownloadingOperations()
    }
    
}

// MARK: - UserListViewModelViewDelegate -

extension ComposersTableViewController: ComposersViewModelViewDelegate
{
    func didLoadComposerImageAtIndex(indexPath: NSIndexPath)
    {
        if((self.tableView.indexPathsForVisibleRows?.contains(indexPath as IndexPath))! == true)
        {
            self.tableView.reloadRows(at: [indexPath as IndexPath], with: .none)
        }
    }
}