//
//  CollectionViewAdapter.swift
//  DataSources
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

open class CollectionViewAdapter: Updating {

  private(set) public weak var collectionView: UICollectionView?

  public init(collectionView: UICollectionView) {
    self.collectionView = collectionView
  }

  public func insertItems(at indexPaths: [IndexPath]) {

    guard let collectionView = collectionView else {
      assertionFailure("CollectionView has released")
      return
    }

    collectionView.insertItems(at: indexPaths)
  }

  public func deleteItems(at indexPaths: [IndexPath]) {

    guard let collectionView = collectionView else {
      assertionFailure("CollectionView has released")
      return
    }

    collectionView.deleteItems(at: indexPaths)
  }

  public func reloadItems(at indexPaths: [IndexPath]) {

    guard let collectionView = collectionView else {
      assertionFailure("CollectionView has released")
      return
    }

    collectionView.reloadItems(at: indexPaths)
  }

  public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {

    guard let collectionView = collectionView else {
      assertionFailure("CollectionView has released")
      return
    }

    collectionView.moveItem(at: indexPath, to: newIndexPath)
  }

  public func performBatch(updates: @escaping () -> Void, completion: @escaping () -> Void) {

    guard let collectionView = collectionView else {
      assertionFailure("CollectionView has released")
      return
    }

    collectionView.performBatchUpdates({
      updates()
    }, completion: { result in
      completion()
    })

  }

  public func reload(completion: @escaping () -> Void) {

    guard let collectionView = collectionView else {
      assertionFailure("CollectionView has released")
      return
    }

    collectionView.reloadData()
    completion()
  }
}
