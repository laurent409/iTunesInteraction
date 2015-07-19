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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        cell.textLabel!.text = "Ligne #\(indexPath.row)"
        cell.detailTextLabel?.text = "Subtitles #\(indexPath.row)"
        
        return cell
    }
    
    func searchItunesFor(searchTerm: String) {
        
        //Replace spaces (" ") by "+" because iTunes ask for multiples requests
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        //Enscape all URL which not friendly
        let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        let urlPath = "https://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        let url: NSURL = NSURL(string: urlPath)!
        
        let session = NSURLSession.sharedSession()
        
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
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.appsTableView!.reloadData()
            })
            
        })
        
        task.resume()
    }
    

}

