//
//  PinterestCollectionViewController.swift
//  PinterestLayoutCollectionViewDemo
//
//  Created by HIROKI IKEUCHI on 2020/12/19.
//

import UIKit

final class PinterestCollectionViewController: UICollectionViewController {
    
    // MARK: - Defines
    
    // 今回は1sectionのみ使用する
    enum Section {
      case main
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PinItem>
    // NSDiffableDataSourceSnapshot: diffable-data-sourceが、
    // 表示するセクションとセルの数の情報を参照するためのクラス
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PinItem>
    
    // MARK: - Properties
    
    private lazy var dataSource = makeDataSource()  // lazy: ViewControllerの初期化後に呼ぶ必要があるため
    private var pinItems = PinItem.demoPinItems()
    private let itemsPerRow = 5
    private var columnFractionalWidth: CGFloat {
        1.0 / CGFloat(itemsPerRow)
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .purple  // CollectionViewにより見えない
        configureCollectionView()
        applySnapshot(animationgDifferences: false)
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .systemGreen
        collectionView.register(PinItemCell.self,
                                forCellWithReuseIdentifier: PinItemCell.reuseIdentifer)
        collectionView.collectionViewLayout = generateLayout()
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, pinItem) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PinItemCell.reuseIdentifer,
                                                          for: indexPath) as? PinItemCell
            cell?.pinItem = pinItem
            return cell
        })
        
        return dataSource
    }
    
    func applySnapshot(animationgDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])  // セクション情報を伝える
        snapshot.appendItems(pinItems)
        // dataSouceに最新のsnapshotのことを伝えて更新する
        dataSource.apply(snapshot, animatingDifferences: animationgDifferences)
    }
    
    func generateLayout() -> UICollectionViewLayout {
        
        let layoutGroup = generateLayoutGroup(withTweets: pinItems)
        
        // NSCollectionLayoutSection: セクションを表すクラス
        // 最終的に作成したNSCollectionLayoutGroupを適用する
        let section = NSCollectionLayoutSection(group: layoutGroup)
        
        // 最終的にレンダリングされる単位になります。
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // TODO: データ数が1とかで足りない場合にクラッシュするので対応が必要です
    func generateLayoutGroup(withTweets pinItems: [PinItem]) -> NSCollectionLayoutGroup {
        
        let columns = calculateAndArrangePinItems(pinItems: pinItems)
        
        // データの更新
        var arrangedPinItems = [PinItem]()
        columns.forEach { column in
            arrangedPinItems.append(contentsOf: column.pinItems)
        }
        self.pinItems = arrangedPinItems
        
        // 全カラムのLayoutGroupを作成
        var columnLayoutGroups = [NSCollectionLayoutGroup]()
        for column in columns {
            // ツイートに関して
            var layoutItems = [NSCollectionLayoutItem]()
            for pinItem in column.pinItems {
                let layoutItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalWidth(pinItem.fractionalHeight)
                    )
                )
                layoutItems.append(layoutItem)
            }
            
            // ツイートをカラムとして並べる
            let columnLayoutGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(columnFractionalWidth),
                    heightDimension: .fractionalWidth(column.calculateFractionalHeight() * columnFractionalWidth)
                ),
                subitems: layoutItems
            )

            columnLayoutGroups.append(columnLayoutGroup)
        }
        
        // Columnを水平に並べる
        // カラムを合算する
        // TODO: 見直し
        var maxHeight: CGFloat = .zero
        columns.forEach { column in
            let height = column.calculateFractionalHeight() * columnFractionalWidth
            if maxHeight < height {
                maxHeight = height
            }
        }
        
        let allColumnsLayoutGroup = NSCollectionLayoutGroup.horizontal(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(maxHeight)
            ),
            subitems: columnLayoutGroups
        )
        
        return allColumnsLayoutGroup
    }
    
    // カラム別にツイートを分割する
    private func calculateAndArrangePinItems(pinItems: [PinItem]) -> [PinItemColumn] {
        // Columnの箱を用意
        var pinItemColumns = [PinItemColumn]()
        for _ in 0..<itemsPerRow {
            pinItemColumns.append(PinItemColumn())
        }
        
        for pinItem in pinItems {
            var minimumHeight = CGFloat.greatestFiniteMagnitude
            var minimumColumnIndex = 0
            
            for (column_i, pinItemColumn) in pinItemColumns.enumerated() {
                // 現在最も低い高さのColumnを探す
                let columnHeight = pinItemColumn.calculateFractionalHeight()  // TODO: reduce 計算量
                if columnHeight < minimumHeight {
                    minimumHeight = columnHeight
                    minimumColumnIndex = column_i
                }
            }
            pinItemColumns[minimumColumnIndex].pinItems.append(pinItem)
        }
        
        return pinItemColumns
    }
}
