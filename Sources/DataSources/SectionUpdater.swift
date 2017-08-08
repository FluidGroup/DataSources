//
//  Updater.swift
//  ListAdapter
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

final class SectionUpdater<T: Diffable, A: Updating> {

  enum State {
    case idle
    case updating
  }

  enum UpdateMode {
    case everything
    case partial(animated: Bool, isEqual: (T, T) -> Bool)
  }

  let adapter: A

  private let queue = DispatchQueue.main
  private var state: State = .idle

  init(adapter: A) {
    self.adapter = adapter
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
      adapter.reload {
        assertMainThread()
        self.state = .idle
        completion()
      }
    case .partial(let animated, let isEqual):

      let diff = Diff.diffing(
        oldArray: currentDisplayingItems,
        newArray: newItems,
        isEqual: isEqual
      )

      var animated = animated

      if diff.changeCount > 300 {
        animated = false
      }

//      guard diff.changeCount < 300 else {
//        // Saving animation cost
//        adapter.reload {
//          assertMainThread()
//          self.state = .idle
//          completion()
//        }
//        return
//      }

      if animated == false {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
      }

      let _adapter = self.adapter

      self.adapter.performBatch(
        updates: {

          _adapter.reloadItems(at: diff.updates.map { IndexPath(item: $0, section: targetSection) })
          _adapter.deleteItems(at: diff.deletes.map { IndexPath(item: $0, section: targetSection) })
          _adapter.insertItems(at: diff.inserts.map { IndexPath(item: $0, section: targetSection) })

          for move in diff.moves {
            _adapter.moveItem(
              at: IndexPath(item: move.from, section: targetSection),
              to: IndexPath(item: move.to, section: targetSection)
            )
          }
      },
        completion: {
          assertMainThread()
          if animated == false {
            CATransaction.commit()
          }
          self.state = .idle
          completion()
      }
      )

    }

  }
}
