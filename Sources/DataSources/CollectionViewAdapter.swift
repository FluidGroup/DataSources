//
//  CollectionViewAdapter.swift
//  DataSources
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

open class CollectionViewAdapter: Updating {

  public unowned let collectionView: UICollectionView

  public var target: UICollectionView {
    return collectionView
  }

  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }

  open func insertItems(at indexPaths: [IndexPath], in context: UpdateContext) {

    collectionView.insertItems(at: indexPaths)
  }

  open func deleteItems(at indexPaths: [IndexPath], in context: UpdateContext) {

    collectionView.deleteItems(at: indexPaths)
  }

  open func reloadItems(at indexPaths: [IndexPath], in context: UpdateContext) {

    collectionView.reloadItems(at: indexPaths)
  }

  open func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath, in context: UpdateContext) {

    collectionView.moveItem(at: indexPath, to: newIndexPath)
  }

  open func performBatch(in context: UpdateContext, animated: Bool, updates: @escaping () -> Void, completion: @escaping () -> Void) {

    if animated {
      collectionView.performBatchUpdates({
        updates()
      }, completion: { result in
        completion()
      })
    } else {

      CATransaction.begin()
      CATransaction.setDisableActions(true)

      collectionView.performBatchUpdates({
        updates()
      }, completion: { result in
        CATransaction.commit()
        completion()
      })
    }

  }

  open func reload(completion: @escaping () -> Void) {

    collectionView.reloadData()
    completion()
  }
}
