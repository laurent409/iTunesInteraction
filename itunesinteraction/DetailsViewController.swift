//
//  DetailsViewController.swift
//  itunesinteraction
//
//  Created by Laurent Philibert on 21/07/2015.
//  Copyright (c) 2015 Laurent Philibert. All rights reserved.
//

import Foundation
import UIKit

class DetailsViewController: UIViewController {
    
    var album: Album?
    
    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageUrl)!)!)
    }
}