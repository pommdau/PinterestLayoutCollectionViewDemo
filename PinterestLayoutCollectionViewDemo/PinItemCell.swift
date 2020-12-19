//
//  PinCell.swift
//  PinterestLayoutCollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/19.
//

import UIKit

class PinItemCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifer = "pin-cell-reuse-identifier"
    
    var pinItem: PinItem? {
        didSet {
            configureUI()
        }
    }
   
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        guard let pinItem = pinItem else { return }
        
        backgroundColor = pinItem.itemColor
    }
}
