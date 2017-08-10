//
//  TableViewAdapter.swift
//  DataSources
//
//  Created by muukii on 8/10/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

open class TableViewAdapter: Updating {

  private(set) public weak var tableView: UITableView?

  public init(tableView: UITableView) {
    self.tableView = tableView
  }

  public func insertItems(at indexPaths: [IndexPath]) {

    guard let tableView = tableView else {
      assertionFailure("tableView has released")
      return
    }

    tableView.insertRows(at: indexPaths, with: .automatic)
  }

  public func deleteItems(at indexPaths: [IndexPath]) {

    guard let tableView = tableView else {
      assertionFailure("tableView has released")
      return
    }

    tableView.deleteRows(at: indexPaths, with: .automatic)
  }

  public func reloadItems(at indexPaths: [IndexPath]) {

    guard let tableView = tableView else {
      assertionFailure("tableView has released")
      return
    }

    tableView.reloadRows(at: indexPaths, with: .automatic)
  }

  public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath) {

    guard let tableView = tableView else {
      assertionFailure("tableView has released")
      return
    }

    tableView.moveRow(at: indexPath, to: newIndexPath)
  }

  public func performBatch(updates: @escaping () -> Void, completion: @escaping () -> Void) {

    guard let tableView = tableView else {
      assertionFailure("tableView has released")
      return
    }

    tableView.beginUpdates()
    updates()
    tableView.endUpdates()
    completion()

  }

  public func reload(completion: @escaping () -> Void) {

    guard let tableView = tableView else {
      assertionFailure("tableView has released")
      return
    }

    tableView.reloadData()
    completion()
  }
}
