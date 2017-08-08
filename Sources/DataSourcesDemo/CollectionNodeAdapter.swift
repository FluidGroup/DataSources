//
//  CollectionNodeAdapter.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import DataSources
import class AsyncDisplayKit.ASCollectionNode

public final class CollectionNodeUpdater: Updating {

  private(set) public weak var collectionNode: ASCollectionNode?

  public init(collectionNode: ASCollectionNode) {
    self.collectionNode = collectionNode
  }

  public func insertItems(at indexPaths: [IndexPath]) {

    guard let collectionNode = collectionNode else {
      assertionFailure("collectionNode has released")
      return
    }

    collectionNode.insertItems(at: indexPaths)
  }

  public func deleteItems(at indexPaths: [IndexPath]) {

    guard let collectionNode = collectionNode else {
      assertionFailure("collectionNode has released")
      return
    }

    collectionNode.deleteItems(at: indexPaths)
  }

  public func reloadItems(at indexPaths: [IndexPath]) {

    guard let collectionNode = collectionNode else {
      assertionFailure("collectionNode has released")
      return
    }

    collectionNode.reloadItems(at: indexPaths)
  }

  public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {

    guard let collectionNode = collectionNode else {
      assertionFailure("collectionNode has released")
      return
    }

    collectionNode.moveItem(at: indexPath, to: newIndexPath)
  }

  public func performBatch(updates: @escaping () -> Void, completion: @escaping () -> Void) {

    guard let collectionNode = collectionNode else {
      assertionFailure("collectionNode has released")
      return
    }

    collectionNode.performBatchUpdates({
      updates()
    }, completion: { result in
      completion()
    })

  }

  public func reload(completion: @escaping () -> Void) {

    guard let collectionNode = collectionNode else {
      assertionFailure("collectionNode has released")
      return
    }

    collectionNode.reloadData {
      completion()
    }
  }
}
