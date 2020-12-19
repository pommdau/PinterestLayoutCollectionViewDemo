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
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
   
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // AutoLayout設定
        addSubview(textLabel)
        textLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureUI() {
        guard let pinItem = pinItem else { return }
        
        backgroundColor = pinItem.itemColor
        textLabel.text = "\(pinItem.serialNumber)"
    }
}
