//
//  CollectionViewAdapter.swift
//  DataSources
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

public struct CollectionViewAdapter<Element>: Updating {

  public unowned let collectionView: UICollectionView

  public var target: UICollectionView {
    return collectionView
  }

  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }

  public func insertItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>) {

    collectionView.insertItems(at: indexPaths)
  }

  public func deleteItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>) {

    collectionView.deleteItems(at: indexPaths)
  }

  public func reloadItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>) {

    collectionView.reloadItems(at: indexPaths)
  }

  public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath, in context: UpdateContext<Element>) {

    collectionView.moveItem(at: indexPath, to: newIndexPath)
  }

  public func performBatch(in context: UpdateContext<Element>, animated: Bool, updates: @escaping () -> Void, completion: @escaping () -> Void) {

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

  public func reload(completion: @escaping () -> Void) {

    collectionView.reloadData()
    completion()
  }
}
