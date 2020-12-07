//
//  FavouritesCollectionViewLayout.swift
//  GiphySample
//
//  Created by Mohamed Afsar on 07/12/20.
//

import UIKit

protocol FavouritesCollectionViewLayoutDelegate: AnyObject {
    func collectionView(_ collectionView: UICollectionView, heightForImageAtIndexPath indexPath: IndexPath) -> CGFloat
}

final class FavouritesCollectionViewLayout: UICollectionViewLayout {
  
    weak var delegate: FavouritesCollectionViewLayoutDelegate?

    // MARK: Private ICons
    private let _numberOfColumns = 2
    private let _cellPadding: CGFloat = 3

    // MARK: Private IVars
    private var _cache: [UICollectionViewLayoutAttributes] = []
    private var _contentHeight: CGFloat = 0

    private var _contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
  
    override var collectionViewContentSize: CGSize {
        return CGSize(width: _contentWidth, height: _contentHeight)
    }
    
    // MARK: Functions
    override func prepare() {
        guard let collectionView = collectionView,
            let itemsCount = self.collectionView?.numberOfItems(inSection: 0),
            itemsCount > 0 else {
            return
        }
        _cache.removeAll()
    
        let columnWidth = _contentWidth / CGFloat(_numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0..<_numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: _numberOfColumns)
      
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            let imageHeight = delegate?.collectionView(collectionView, heightForImageAtIndexPath: indexPath) ?? 180
            let height = _cellPadding * 2 + imageHeight
            let frame = CGRect(x: xOffset[column], y: yOffset[column],
                             width: columnWidth, height: height)
            let insetFrame = frame.insetBy(dx: _cellPadding, dy: _cellPadding)

            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            _cache.append(attributes)

            _contentHeight = max(_contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height            
            column = column < (_numberOfColumns - 1) ? (column + 1) : 0
        }
    }
  
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        for attributes in _cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }
  
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return _cache[indexPath.item]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
