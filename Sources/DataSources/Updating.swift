//
//  Updating.swift
//  DataSources
//
//  Created by muukii on 8/7/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public struct UpdateContext {
  public let newItems: LazyMapCollection<CountableRange<Array<Any>.Index>, IndexPath>
  public let oldItems: LazyMapCollection<CountableRange<Array<Any>.Index>, IndexPath>
  public let diff: DiffResultType

  init(
    newItems: LazyMapCollection<CountableRange<Array<Any>.Index>, IndexPath>,
    oldItems: LazyMapCollection<CountableRange<Array<Any>.Index>, IndexPath>,
    diff: DiffResultType
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
