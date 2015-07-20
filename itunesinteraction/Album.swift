//
//  Album.swift
//  itunesinteraction
//
//  Created by Laurent Philibert on 20/07/2015.
//  Copyright (c) 2015 Laurent Philibert. All rights reserved.
//

import Foundation

struct Album {
    let title: String
    let price: String
    let thumbnailImageUrl: String
    let largeImageUrl: String
    let itemUrl: String
    let artistUrl: String
    
    init(title: String, price: String, thumbnailImageUrl: String, largeImageUrl: String, itemUrl: String, artistUrl: String) {
        
        self.title = title
        self.price = price
        self.thumbnailImageUrl = thumbnailImageUrl
        self.largeImageUrl = largeImageUrl
        self.itemUrl = itemUrl
        self.artistUrl = artistUrl
    }
    
    static func albumsWithJson(results: NSArray) -> [Album] {
        //code here for albumsWithJson method
    }
}