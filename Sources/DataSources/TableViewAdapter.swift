//
//  TableViewAdapter.swift
//  DataSources
//
//  Created by muukii on 8/10/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

open class TableViewAdapter: Updating {

  public unowned let tableView: UITableView

  public var target: UITableView {
    return tableView
  }

  public init(tableView: UITableView) {
    self.tableView = tableView
  }

  public func insertItems(at indexPaths: [IndexPath], in context: UpdateContext) {

    tableView.insertRows(at: indexPaths, with: .automatic)
  }

  public func deleteItems(at indexPaths: [IndexPath], in context: UpdateContext) {

    tableView.deleteRows(at: indexPaths, with: .automatic)
  }

  public func reloadItems(at indexPaths: [IndexPath], in context: UpdateContext) {

    tableView.reloadRows(at: indexPaths, with: .automatic)
  }

  public func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath, in context: UpdateContext) {

    tableView.moveRow(at: indexPath, to: newIndexPath)
  }

  public func performBatch(in context: UpdateContext, animated: Bool, updates: @escaping () -> Void, completion: @escaping () -> Void) {

    if animated {
      tableView.beginUpdates()
      updates()
      tableView.endUpdates()
      completion()
    } else {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      tableView.beginUpdates()
      updates()
      tableView.endUpdates()
      completion()
      CATransaction.commit()
    }

  }

  public func reload(completion: @escaping () -> Void) {

    tableView.reloadData()
    completion()
  }
}
