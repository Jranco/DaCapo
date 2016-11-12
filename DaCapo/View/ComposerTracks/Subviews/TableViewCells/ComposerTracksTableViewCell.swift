//
//  ComposerTracksTableViewCell.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 12/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit
import Reusable

class ComposerTracksTableViewCell: UITableViewCell, NibReusable
{
    // MARK: - Subviews

    @IBOutlet var trackImageView: UIImageView!
    @IBOutlet var trackTitle: UILabel!
    @IBOutlet var trackDescription: UILabel!
    
    // MARK: - DataSource

    var composerTrackData: ComposerSnippetTrackVO? {
        
        didSet {
            
            if let composerTrackData = composerTrackData
            {
                if(composerTrackData.title != nil)
                {
                    trackTitle.text = composerTrackData.title
                }
                
                if(composerTrackData.description != nil)
                {
                    trackDescription.text = composerTrackData.description
                }
                
                if(composerTrackData.mainImage != nil)
                {
                    trackImageView.image = composerTrackData.mainImage
                }
                else
                {
                    trackImageView.image = UIImage(named: "ComposerPlaceholder")!
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
