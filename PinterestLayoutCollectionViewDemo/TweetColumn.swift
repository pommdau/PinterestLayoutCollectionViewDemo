//
//  TweetColumn.swift
//  PinterestLayoutCollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/19.
//

import UIKit

struct PinItemColumn {
    var pinItems = [PinItem]()
    
    // columnの幅を1.0としたときのcolumnの高さ
    func calculateFractionalHeight() -> CGFloat {
        var columnFractionalHeight: CGFloat = .zero
        for pinItem in pinItems {
            columnFractionalHeight += pinItem.fractionalHeight
        }
        
        return columnFractionalHeight
    }
}

