//
//  Updating.swift
//  DataSources
//
//  Created by muukii on 8/7/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public struct IndexPathDiff {

  public struct Move {
    let from: IndexPath
    let to: IndexPath
  }

  public let inserts: [IndexPath]

  public let updates: [IndexPath]

  public let deletes: [IndexPath]

  public let moves: [Move]

  init(diff: DiffResultType, targetSection: Int) {
    self.updates = diff.updates.map { IndexPath(item: $0, section: targetSection) }
    self.inserts = diff.inserts.map { IndexPath(item: $0, section: targetSection) }
    self.deletes = diff.deletes.map { IndexPath(item: $0, section: targetSection) }
    self.moves = diff.moves.map {
      Move(
        from: IndexPath(item: $0.from, section: targetSection),
        to: IndexPath(item: $0.to, section: targetSection)
      )
    }
  }
}

public struct UpdateContext {

  public let newItems: LazyMapCollection<CountableRange<Array<Any>.Index>, IndexPath>
  public let oldItems: LazyMapCollection<CountableRange<Array<Any>.Index>, IndexPath>
  public let diff: IndexPathDiff

  init(
    newItems: LazyMapCollection<CountableRange<Array<Any>.Index>, IndexPath>,
    oldItems: LazyMapCollection<CountableRange<Array<Any>.Index>, IndexPath>,
    diff: IndexPathDiff
    ) {
    
    self.newItems = newItems
    self.oldItems = oldItems
    self.diff = diff
  }
}

public protocol Updating : class {

  associatedtype Target

  var target: Target { get }

  func insertItems(at indexPaths: [IndexPath], in context: UpdateContext)

  func deleteItems(at indexPaths: [IndexPath], in context: UpdateContext)

  func reloadItems(at indexPaths: [IndexPath], in context: UpdateContext)

  func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath, in context: UpdateContext)

  func performBatch(in context: UpdateContext, animated: Bool, updates: @escaping () -> Void, completion: @escaping () -> Void)

  func reload(completion: @escaping () -> Void)
}
