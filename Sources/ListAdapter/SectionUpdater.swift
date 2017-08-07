//
//  Updater.swift
//  ListAdapter
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public final class SectionUpdater<T: Diffable, L: ListUpdating> {

  enum UpdateMode {
    case whole
    case partial(isEqual: (T, T) -> Bool)
  }

  public let list: L

  init(list: L) {
    self.list = list
  }

  func update(targetSection: Int, currentDisplayingItems: [T], newItems: [T], updateMode: UpdateMode, completion: @escaping () -> Void) {

//    guard let list = list else {
//      assertionFailure("List has released")
//      return
//    }

    switch updateMode {
    case .whole:
      list.reload(completion: completion)
    case .partial(let isEqual):
      let diff = Diff.diffing(oldArray: currentDisplayingItems, newArray: newItems, isEqual: isEqual)

      list.performBatch(
        updates: {

          list.reloadItems(at: diff.updates.map { IndexPath(item: $0, section: targetSection) })
          list.deleteItems(at: diff.deletes.map { IndexPath(item: $0, section: targetSection) })
          list.insertItems(at: diff.inserts.map { IndexPath(item: $0, section: targetSection) })

          for move in diff.moves {
            list.moveItem(
              at: IndexPath(item: move.from, section: targetSection),
              to: IndexPath(item: move.to, section: targetSection)
            )
          }
      },
        completion: completion
      )
    }
  }
}
