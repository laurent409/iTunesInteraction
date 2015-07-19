//
//  SearchResultsViewController.swift
//  itunesinteraction
//
//  Created by Laurent Philibert on 18/07/2015.
//  Copyright (c) 2015 Laurent Philibert. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    var api = APIController()
    var tableData = []
    @IBOutlet var appsTableView : UITableView?
    
    override func viewDidLoad() {
        
        self.api.delegate = self
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Begin the iTunes answer seek when we ask it
        api.searchItunesFor("Angry Birds")
        
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
    
    func didReceiveAPIResults(results: NSDictionary) {
        var resultsArray: NSArray = results["results"] as! NSArray
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = resultsArray
            self.appsTableView?.reloadData()
        })
    }

}

