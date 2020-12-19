//
//  PinItemColumn.swift
//  PinterestLayoutCollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/19.
//

import UIKit

struct PinItemColumn {
    
    // MARK: - Properties
    
    var pinItems = [PinItem]()
    
    // MARK: - Lifecycle
    
    // MARK: - Helpers
    
    // columnの幅を1.0としたときのcolumnの高さ
    func calculateFractionalHeight() -> CGFloat {
        var columnFractionalHeight: CGFloat = .zero
        for pinItem in pinItems {
            columnFractionalHeight += pinItem.fractionalHeight
        }
        
        return columnFractionalHeight
    }
}

