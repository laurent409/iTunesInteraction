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
        var albums = [Album]()
        if results.count>0 {
            for results in results {
                var name = results["trackName"] as? String
                if name == nil {
                    name = results["collectionName"] as? String
                }
                
                var price = results["formattedPrice"] as? String
                if price == nil {
                    price = results["collectionPrice"] as? String
                    if price == nil {
                        var priceFloat: Float? = results["collectionPrice"] as? Float
                        var nf: NSNumberFormatter = NSNumberFormatter()
                        nf.maximumFractionDigits = 2
                        if priceFloat != nil {
                            price = "$\(nf.stringFromNumber(priceFloat!)!)"
                        }
                    }
                }
                
                let thumbnailUrl = results["artworkUrl60"] as? String ?? ""
                let imageUrl = results["artworkUrl100"] as? String ?? ""
                let artistUrl = results["artistViewUrl"] as? String ?? ""
                
                var itemUrl = results["collectionViewUrl"] as? String
                if itemUrl == nil {
                    itemUrl = results["trackViewUrl"] as? String
                }
                
                var newAlbum = Album(title: name!, price: price!, thumbnailImageUrl: thumbnailUrl, largeImageUrl: imageUrl, itemUrl: itemUrl!, artistUrl: artistUrl)
                albums.append(newAlbum)
                
            }
        }
        return albums
    }
}