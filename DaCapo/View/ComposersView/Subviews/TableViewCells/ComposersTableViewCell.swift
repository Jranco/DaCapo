//
//  UserListTableViewCell.swift
//  JRAGithubUsers
//
//  Created by Thomas Segkoulis on 28/09/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit
import Reusable

class ComposersTableViewCell: UITableViewCell, NibReusable
{
    // MARK: - Subviews


    @IBOutlet var composerImageView: UIImageView!
    @IBOutlet var composerNameLabel: UILabel!
    
    // MARK: - DataSource
    
    var composerData: ComposerVO? {
        
        didSet {
            
            if let composerData = composerData
            {
                if(composerData.name != nil)
                {
                    composerNameLabel.text = composerData.name
                }
                
                if(composerData.mainImage != nil)
                {
                    composerImageView.image = composerData.mainImage
                }
                else
                {
                    composerImageView.image = UIImage(named: "ComposerPlaceholder")!
                }
                                
            }
            else
            {
                
            }
        }
    }

    // MARK: - LifeCycle

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
}
