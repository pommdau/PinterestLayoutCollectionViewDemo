//
//  PinItem.swift
//  PinterestLayoutCollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/19.
//

import UIKit

struct PinItem: Hashable {
    
    // MARK: - Methods for Hashable
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }

    static func == (lhs: PinItem, rhs: PinItem) -> Bool {
      lhs.id == rhs.id
    }
    
    // MARK: - Properties
    
    var id = UUID().uuidString
    var serialNumber: Int  // 通し番号（レイアウトのために設定）
    var itemColor = UIColor.random()
    // cellの幅を1.0としたときの相対的なcellの高さ。
    // 実際はコンテンツに合わせて計算する
    var fractionalHeight = CGFloat.random(in: 0.5...2.0)
}

extension PinItem {
    
    // MARK: - Static Methods
    
    static func demoPinItems() -> [PinItem] {
        var pinItems = [PinItem]()
        
        for i in 0..<100 {
            pinItems.append(PinItem(serialNumber: i))
        }

        return pinItems
    }
}
