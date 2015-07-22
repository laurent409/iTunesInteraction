//
//  DetailsViewController.swift
//  itunesinteraction
//
//  Created by Laurent Philibert on 21/07/2015.
//  Copyright (c) 2015 Laurent Philibert. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {
    
    var album: Album?
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tracksTableView: UITableView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageUrl)!)!)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}