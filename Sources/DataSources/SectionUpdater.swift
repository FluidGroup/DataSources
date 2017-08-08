//
//  Updater.swift
//  ListAdapter
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

final class SectionUpdater<T: Diffable, L: Updating> {

  enum State {
    case idle
    case updating
  }

  enum UpdateMode {
    case everything
    case partial(isAnimated: Bool, isEqual: (T, T) -> Bool)
  }

  let list: L

  private let queue = DispatchQueue.main
  private var state: State = .idle

  init(list: L) {
    self.list = list
  }

  func update(
    targetSection: Int,
    currentDisplayingItems: [T],
    newItems: [T],
    updateMode: UpdateMode,
    completion: @escaping () -> Void
    ) {

    assertMainThread()

    self.state = .updating

    switch updateMode {
    case .everything:
      list.reload {
        assertMainThread()
        self.state = .idle
        completion()
      }
    case .partial(let isAnimated, let isEqual):

      let diff = Diff.diffing(
        oldArray: currentDisplayingItems,
        newArray: newItems,
        isEqual: isEqual
      )

      guard diff.changeCount < 100 else {
        // Saving animation cost
        list.reload {
          assertMainThread()
          self.state = .idle
          completion()
        }
        return
      }

      if isAnimated == false {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
      }

      self.list.performBatch(
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
        completion: {
          assertMainThread()
          CATransaction.commit()
          self.state = .idle
          completion()
      }
      )

    }

  }
}
