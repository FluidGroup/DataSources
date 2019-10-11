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

public final class CollectionNodeAdapter<Element>: Updating {

  public unowned let collectionNode: ASCollectionNode

  public var target: ASCollectionNode {
    return collectionNode
  }

  public init(collectionNode: ASCollectionNode) {
    self.collectionNode = collectionNode
  }

  public func insertItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>) {

    collectionNode.insertItems(at: indexPaths)
  }

  public func deleteItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>) {

    collectionNode.deleteItems(at: indexPaths)
  }

  public func reloadItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>) {

    collectionNode.reloadItems(at: indexPaths)
  }

  public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath, in context: UpdateContext<Element>) {

    collectionNode.moveItem(at: indexPath, to: newIndexPath)
  }

  public func performBatch(in context: UpdateContext<Element>, animated: Bool, updates: @escaping () -> Void,  completion: @escaping () -> Void) {

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
