//
//  Updating.swift
//  DataSources
//
//  Created by muukii on 8/7/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public protocol Updating : class {

  associatedtype Target

  var target: Target { get }

  func insertItems(at indexPaths: [IndexPath])

  func deleteItems(at indexPaths: [IndexPath])

  func reloadItems(at indexPaths: [IndexPath])

  func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath)

  func performBatch(animated: Bool, updates: @escaping () -> Void, completion: @escaping () -> Void)

  func reload(completion: @escaping () -> Void)
}
