//
//  ServiceManager.swift
//  DaCapo
//
//  Created by Thomas Segkoulis on 08/11/16.
//  Copyright © 2016 Thomas Segkoulis. All rights reserved.
//

import Alamofire


/**
 The class 'GithubServices' is responsible for creating and managing `Request` objects, as well as their underlying `NSURLSession`.
 
 */
class ServiceManager
{
    /**
     TrlServiceManager instance
     
    */
    static let sharedInstance: ServiceManager = ServiceManager()
    
    /**
     Alamofire.Manager
     
    */
    var manager: Alamofire.SessionManager
    
    /**
     TrlServiceManager instance
     
    */
    var headerToken: [NSObject: AnyObject]?
    
    // MARK: - LifeCycle -
    
    /**
     Init method
     Do initial configuration of the service controller here.
     
    */
    private init()
    {
        let configuration  = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest  = 30
        configuration.timeoutIntervalForResource = 30

        let defaultHeaders = SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        /*
        * Add Custom Headers with token, if it exists
        */
        if(headerToken != nil)
        {
            configuration.httpAdditionalHeaders = defaultHeaders
        }
        
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    // MARK: - Set/Remove 'x-access-token' header -
    
    /**
     Adds a new Header to the serviceManager with the given token string
     @param token: NSString, token to be set to the header
     
     */
    func setToken(token: NSString)
    {
        self.updateServiceManager()
    }
    
    /**
     Removes the token Header from the serviceManager
     
     */
    func unsetToken()
    {
        self.headerToken = nil
        self.updateServiceManager()
    }
    
    // MARK: - Helpers -
    
    /**
     Updates serviceManager
     
    */
    func updateServiceManager()
    {
        let configuration  = URLSessionConfiguration.default
        let defaultHeaders = SessionManager.default.session.configuration.httpAdditionalHeaders ?? [:]
        
        configuration.httpAdditionalHeaders = defaultHeaders
        
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
}
