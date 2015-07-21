//
//  SearchResultsViewController.swift
//  itunesinteraction
//
//  Created by Laurent Philibert on 18/07/2015.
//  Copyright (c) 2015 Laurent Philibert. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol  {
    
    @IBOutlet var appsTableView : UITableView?
    
    var api: APIController!
    var albums = [Album]()
    var imageCache = [String: UIImage]()
    
    let kCellIdentifier: String = "SearchResultCell"
    
    override func viewDidLoad() {
        
//        self.api.delegate = self
//        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Background.jpg")!)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        api = APIController(delegate: self)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        //Begin the iTunes answer seek when we ask it
        api.searchItunesFor("Beatles")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
////        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(kCellIdentifier) as! UITableViewCell
//        let rowData: NSDictionary = self.tableData[indexPath.row] as! NSDictionary
        let album = self.albums[indexPath.row]

//        let cellText: String? = rowData["trackName"] as? String
        cell.textLabel!.text = album.title
        cell.detailTextLabel?.text = album.price
        cell.imageView?.image = UIImage(named: "Blank52")
        
        //Get price as formatted string for displaying in the subtitle
//        let formattedPrice: NSString = rowData["formattedPrice"] as! NSString
        let thumbnailUrlString = album.thumbnailImageUrl
        let thumbnailUrl = NSURL(string: thumbnailUrlString)!
        
        if let img = imageCache[thumbnailUrlString] {
            cell.imageView?.image = img
        } else {
            let request: NSURLRequest = NSURLRequest(URL: thumbnailUrl)
            let mainQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: {
                (response, data, error) -> Void in
                if error == nil {
                    let image = UIImage(data: data)
                    self.imageCache[thumbnailUrlString] = image
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) {
                            cellToUpdate.imageView?.image = image
                        }
                    })
                } else {
                    println("Error: \(error.localizedDescription)")
                }
            })
        }
        return cell
    }
    
    
    func didReceiveAPIResults(results: NSArray) {
//        var resultsArray: NSArray = results["results"] as! NSArray
        dispatch_async(dispatch_get_main_queue(), {
//            self.tableData = resultsArray
            self.albums = Album.albumsWithJson(results)
            self.appsTableView!.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var rowData: NSDictionary = self.albums[indexPath.row] as! NSDictionary
//        
//        var name: String = rowData["trackName"] as! String
//        var formattedPrice: String = rowData["formattedPrice"] as! String
//        
//        var alert: UIAlertView = UIAlertView()
//        alert.title = name
//        alert.message = formattedPrice
//        alert.addButtonWithTitle("OK")
//        alert.show()
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let detailsViewController: DetailsViewController = segue.destinationViewController as? DetailsViewController {
            var albumIndex = appsTableView!.indexPathForSelectedRow()!.row
            var selectedAlbum = self.albums[albumIndex]
            detailsViewController.album = selectedAlbum
        }
    }

}

