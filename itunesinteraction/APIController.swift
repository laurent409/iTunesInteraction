//
//  APIController.swift
//  itunesinteraction
//
//  Created by Laurent Philibert on 19/07/2015.
//  Copyright (c) 2015 Laurent Philibert. All rights reserved.
//

import Foundation

protocol APIControllerProtocol {
    func didReceiveAPIResults(results: NSArray)
}

class APIController {
    
    var delegate: APIControllerProtocol
    
    init(delegate: APIControllerProtocol){
        self.delegate = delegate
    }
    
    func searchItunesFor(searchTerm: String) {
        
        //Replace spaces (" ") by "+" because iTunes ask for multiples requests
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        //Present an URL for API
        //        let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        
        //Enscape all URL which not friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let firstPartUrl = "https://itunes.apple.com/search?term="
            let secondPartUrl = "&media=music&entity=album"
            let urlPath = firstPartUrl + escapedSearchTerm + secondPartUrl
            let urlString: NSString = urlPath as NSString
            get(urlString as String)
        }
        
    }
    
    func get(path: String) {
        let url = NSURL(string: path)
        
        //Get default session
        let session = NSURLSession.sharedSession()
        
        //Create connection task
        let task = session.dataTaskWithURL(url!, completionHandler: { data, response, error -> Void in println("Task Completed !")
            if ((error) != nil) {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if ( (err) != nil ) {
                
                println("JSON error : \(err!.localizedDescription)")
            }
            let results: NSArray = jsonResult["results"] as! NSArray
            self.delegate.didReceiveAPIResults(results)
            
            //Update UI, Come back to the thread, Reload the table view
            //            dispatch_async(dispatch_get_main_queue(), {
            //                self.tableData = results
            //                self.appsTableView!.reloadData()
            //            })
            
        })
        
        //Begin request
        task.resume()
        
    }
    
}