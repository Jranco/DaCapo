//
//  ContactImageView.swift
//  JContact
//
//  Created by Thomas Segkoulis on 13/07/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import UIKit
import Alamofire

class UserImageView: UIView
{
    // MARK:- Subviews
    
    var userImageView: UIImageView?
    var userImagePlaceholder: UILabel?
    
    // MARK:- LifeCycle
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
 
        setupSubviews()
    }
    
    // MARK:- Subviews setup
    
    func setupSubviews()
    {
        // SuperView
        backgroundColor    = UIColor.clear
        layer.borderColor  = UIColor.black.cgColor
        layer.cornerRadius = self.frame.size.width / 2
        clipsToBounds      = true
        
        // contactImageView
        userImageView              = UIImageView.init(frame: self.bounds)
        userImageView?.contentMode = UIViewContentMode.scaleAspectFill
        userImageView?.isHidden      = true
        userImageView?.setRoundedCorners()

        // contactImagePlaceholder
        userImagePlaceholder                = UILabel.init(frame: self.bounds)
        userImagePlaceholder?.textColor     = UIColor.black
        userImagePlaceholder?.isHidden        = true
        userImagePlaceholder?.textAlignment = NSTextAlignment.center
        userImagePlaceholder?.adjustsFontSizeToFitWidth = true

        addSubview(userImageView!)
        addSubview(userImagePlaceholder!)
    }
    
    // MARK:- Public methods
    
    func setImage(image: UIImage)
    {
        layer.borderWidth  = 0.0
        
        userImageView?.isHidden        = false
        userImagePlaceholder?.isHidden = true
        
        userImageView?.image = image
    }
    
    func setMainImageData(imageData: NSData?, userLastName: String?, userFirstName: String?)
    {
        if(imageData != nil)
        {
            layer.borderWidth  = 0.0

            userImageView?.isHidden        = false
            userImagePlaceholder?.isHidden = true
            
            DispatchQueue.global().async {
                
                let image = UIImage(data: imageData! as Data)

                DispatchQueue.main.sync {
                 
                    self.userImageView?.image = image
                }
            }
        }
        else
        {
            layer.borderWidth  = 1.0

            userImageView?.isHidden        = true
            userImagePlaceholder?.isHidden = false
            
            var strName = "" as String
            
            if(userFirstName != nil && (userFirstName?.characters.count)! >= 1)
            {
                strName = strName + (userFirstName! as NSString).substring(to: 1)
            }
            
            if(userLastName != nil && (userLastName?.characters.count)! >= 1)
            {
                strName = strName + (userLastName!as NSString).substring(to: 1)
            }
            
            userImagePlaceholder?.text = strName
        }
    }

}
