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
    // MARK: - Properties - 
    
    var searchDelayer: Timer?
    
    // MARK: - UISearchController -
    
    let searchController = UISearchController.init(searchResultsController: nil)
    
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
        
        // Configure Search Controler
        searchController.searchResultsUpdater             = self
        searchController.searchBar.delegate               = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext                        = true
        tableView.tableHeaderView                         = searchController.searchBar
        
        // Register custom UITableViewCells
        self.tableView.registerReusableCell(ComposersTableViewCell.self)
        self.tableView.registerReusableCell(LoadingMoreTableViewCell.self)
        
        tableView.tableFooterView = UIView()
        
        // Configure UIRefreshControl
//        refreshControl = UIRefreshControl()
//        refreshControl!.attributedTitle = NSAttributedString(string: NSLocalizedString("kPullToRefresh", comment: ""))
//        refreshControl!.addTarget(self, action: #selector(refreshUserList), for: UIControlEvents.valueChanged)
        
        // Set title
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
        
        tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        tableView.setNeedsUpdateConstraints()
        tableView.setNeedsLayout()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - UITableViewDatasource -
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
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
        if(viewModel?.typeOfCellAtIndexPath(indexPath: indexPath) == ComposerListCellType.LoadMoreComposers)
        {
            return loadingMoreUsersTableViewCell(indexPath: indexPath)
        }
        else
        {
            return composersTableViewCell(indexPath: indexPath)
        }
    }
    
    func loadingMoreUsersTableViewCell(indexPath: NSIndexPath) -> LoadingMoreTableViewCell
    {
        let cell = tableView.dequeueReusableCell(indexPath: indexPath as IndexPath) as LoadingMoreTableViewCell
        
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
        return Constants.ComposerTableViewController.ComposerListTableViewCellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard tableView.cellForRow(at: indexPath)?.isKind(of: ComposersTableViewCell.self) == true else {return}

        self.viewModel?.showRelativeTracksForComposerAtIndex(indexPath: indexPath as NSIndexPath)
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        self.viewModel!.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath as NSIndexPath)
    }
    
    // MARK: - RefreshControl action -
    
    func refreshUserList(sender:AnyObject)
    {
        self.tableView.isUserInteractionEnabled = false
        
        self.viewModel?.refreshComposers(
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
    
    // MARK: - Search Composers -
    
    func searchComposers()
    {
        guard (searchController.isActive) &&  (searchController.searchBar.text != nil) else { return }
        
        viewModel?.searchComposers(withName: searchController.searchBar.text!)
        
        self.refreshUserList(sender: self)
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

// MARK: - UISearchBarDelegate -

extension ComposersTableViewController: UISearchBarDelegate
{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        searchDelayer?.invalidate()
        viewModel?.cancelSearchComposers()
        
        tableView.reloadData()
    }
}

extension ComposersTableViewController: UISearchResultsUpdating
{
    func updateSearchResults(for searchController: UISearchController)
    {
        searchDelayer?.invalidate()
        
        searchDelayer = Timer.scheduledTimer(timeInterval: 0.5,
                                                   target: self,
                                                 selector: #selector(searchComposers),
                                                 userInfo: nil,
                                                  repeats: false)
    }
}
