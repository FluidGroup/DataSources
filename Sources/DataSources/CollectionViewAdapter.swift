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

  public func insertItems(at indexPaths: [IndexPath]) {

    collectionView.insertItems(at: indexPaths)
  }

  public func deleteItems(at indexPaths: [IndexPath]) {

    collectionView.deleteItems(at: indexPaths)
  }

  public func reloadItems(at indexPaths: [IndexPath]) {

    collectionView.reloadItems(at: indexPaths)
  }

  public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {

    collectionView.moveItem(at: indexPath, to: newIndexPath)
  }

  public func performBatch(updates: @escaping () -> Void, completion: @escaping () -> Void) {

    collectionView.performBatchUpdates({
      updates()
    }, completion: { result in
      completion()
    })

  }

  public func reload(completion: @escaping () -> Void) {

    collectionView.reloadData()
    completion()
  }
}
