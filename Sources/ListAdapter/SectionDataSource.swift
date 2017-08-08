//
//  SectionDataSource.swift
//  ListAdapter
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public final class SectionDataSource<T: Diffable, L: ListUpdating> {

  // MARK: - Properties

  private(set) public var items: [T] = []

  private var snapshot: [T] = []

  private let updater: SectionUpdater<T, L>

  public var displayingSection: Int

  private let isEqual: (T, T) -> Bool

  // MARK: - Initializers

  public init(list: L, displayingSection: Int, isEqual: @escaping (T, T) -> Bool) {
    self.updater = SectionUpdater(list: list)
    self.isEqual = isEqual
    self.displayingSection = displayingSection
  }

  // MARK: - Functions

  public func numberOfItems() -> Int {
    return snapshot.count
  }

  public func item(for indexPath: IndexPath) -> T {
    let index = toIndex(from: indexPath)
    return snapshot[index]
  }

  public func update(items: [T], updatePartially: Bool, completion: @escaping () -> Void) {

    let old = snapshot
    snapshot = items

    updater.update(
      targetSection: displayingSection,
      currentDisplayingItems: old,
      newItems: items,
      updateMode: updatePartially ? .partial(isEqual: isEqual) : .whole,
      completion: completion
    )
  }

  // Exp
  func update(mutate: (inout ChangesCollection<T>), updatePartially: Bool, completion: @escaping () -> Void) {
    // FIXME:
  }

  @inline(__always)
  private func toIndex(from indexPath: IndexPath) -> Int {
    assert(indexPath.section == displayingSection, "IndexPath.section (\(indexPath.section)) must be equal to displayingSection (\(displayingSection)).")
    return indexPath.item
  }
}

extension SectionDataSource where T : Equatable {

  public convenience init(list: L, displayingSection: Int) {
    self.init(list: list, displayingSection: displayingSection, isEqual: { a, b in a == b })
  }
}
