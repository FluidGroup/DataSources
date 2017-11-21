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

public final class CollectionNodeAdapter: Updating {

  public unowned let collectionNode: ASCollectionNode

  public var target: ASCollectionNode {
    return collectionNode
  }

  public init(collectionNode: ASCollectionNode) {
    self.collectionNode = collectionNode
  }

  public func insertItems(at indexPaths: [IndexPath]) {

    collectionNode.insertItems(at: indexPaths)
  }

  public func deleteItems(at indexPaths: [IndexPath]) {

    collectionNode.deleteItems(at: indexPaths)
  }

  public func reloadItems(at indexPaths: [IndexPath]) {

    collectionNode.reloadItems(at: indexPaths)
  }

  public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {

    collectionNode.moveItem(at: indexPath, to: newIndexPath)
  }

  public func performBatch(animated: Bool, updates: @escaping () -> Void,  completion: @escaping () -> Void) {

    collectionNode.performBatch(
      animated: animated,
      updates: updates,
      completion: { _ in
        completion()
    }
    )
  }

  public func reload(completion: @escaping () -> Void) {

    collectionNode.reloadData {
      completion()
    }
  }
}
