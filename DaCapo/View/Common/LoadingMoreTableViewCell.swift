//
//  LoadingMoreUsersTableViewCell.swift
//  JRAGithubUsers
//
//  Created by Thomas Segkoulis on 28/09/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit
import Reusable

class LoadingMoreTableViewCell: UITableViewCell, NibReusable
{

    // MARK: - Subviews
    
    @IBOutlet var labelLoadingMore: UILabel!
    @IBOutlet var spinner: UIActivityIndicatorView!
    

    // MARK: - LifeCycle

    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        self.labelLoadingMore.text = NSLocalizedString("kLoadingMoreContent", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
