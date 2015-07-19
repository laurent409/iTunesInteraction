//
//  ViewController.swift
//  itunesinteraction
//
//  Created by Laurent Philibert on 18/07/2015.
//  Copyright (c) 2015 Laurent Philibert. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableData = []
    @IBOutlet var appsTableView : UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Begin the iTunes answer seek when we ask it
        searchItunesFor("JQ Software")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
        cell.textLabel!.text = rowData["trackName"] as? String
        
        //Take artworkUrl60 key for getting image URL for the application miniature
        let urlString: NSString = rowData["artworkUrl60"] as! NSString
        let imgUrl: NSURL = NSURL(string: urlString as String)!
        
        //NSData representation of this URL image
        let imgData: NSData = NSData(contentsOfURL: imgUrl)!
        cell.imageView?.image = UIImage(data: imgData)
        
        //Get price as formatted string for displaying in the subtitle
        let formattedPrice: NSString = rowData["formattedPrice"] as! NSString
        
        cell.detailTextLabel!.text = formattedPrice as String

        return cell
    }
    
    func searchItunesFor(searchTerm: String) {
        
        //Replace spaces (" ") by "+" because iTunes ask for multiples requests
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        //Enscape all URL which not friendly
        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)

        //Present an URL for API
//        let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        let firstPartUrl = "https://itunes.apple.com/search?term="
        let secondPartUrl = "&media=software"
        let urlPath = firstPartUrl + escapedSearchTerm! + secondPartUrl
        let urlString: NSString = urlPath as NSString
        
        let url = NSURL(string: urlPath)!
        
        //Get default session
        let session = NSURLSession.sharedSession()
        
        //Create connection task
        let task = session.dataTaskWithURL(url, completionHandler: { data, response, error -> Void in println("Task Completed !")
            
            if ((error) != nil) {
                println(error.localizedDescription)
            }
            
            var err: NSError?
            
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as! NSDictionary
            
            if ( (err) != nil ) {
                
                println("JSON error : \(err!.localizedDescription)")
            }
            
            let results: NSArray = jsonResult["results"] as! NSArray
            
            //Update UI, Come back to the thread, Reload the table view
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.appsTableView!.reloadData()
            })
            
        })
        
        //Begin request
        task.resume()
    }
    

}

