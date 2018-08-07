//
//  Updating.swift
//  DataSources
//
//  Created by muukii on 8/7/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import DifferenceKit

public struct IndexPathDiff {

  public struct Move {
    let from: IndexPath
    let to: IndexPath
  }

  public let inserts: [IndexPath]

  public let updates: [IndexPath]

  public let deletes: [IndexPath]

  public let moves: [Move]

  init<T>(diff: Changeset<T>, targetSection: Int) {
    self.updates = diff.elementUpdated.map { IndexPath(item: $0.element, section: targetSection) }
    self.inserts = diff.elementInserted.map { IndexPath(item: $0.element, section: targetSection) }
    self.deletes = diff.elementDeleted.map { IndexPath(item: $0.element, section: targetSection) }
    self.moves = diff.elementMoved.map {
      Move(
        from: IndexPath(item: $0.source.element, section: targetSection),
        to: IndexPath(item: $0.target.element, section: targetSection)
      )
    }
  }
}

public struct UpdateContext {

  public let diff: IndexPathDiff

  init(
    diff: IndexPathDiff
    ) {

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
