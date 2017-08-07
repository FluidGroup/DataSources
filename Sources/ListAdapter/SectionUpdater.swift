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
    case partial(isEqual: (Diffable, Diffable) -> Bool)
  }

  private(set) public weak var list: L?

  init(list: L) {
    self.list = list
  }

  func update(currentDisplayingItems: [T], newItems: [T], updateMode: UpdateMode, completion: @escaping () -> Void) {

    guard let list = list else {
      assertionFailure("List has released")
      return
    }

    switch updateMode {
    case .whole:
      list.reload(completion: completion)
    case .partial(let isEqual):
      let diff = Diff.diffing(oldArray: currentDisplayingItems, newArray: newItems, isEqual: isEqual)
    }
  }
}
