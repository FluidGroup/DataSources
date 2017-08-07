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

  private var snapshot: [T]?

  private let updater: SectionUpdater<T, L>

  public var displayingSection: Int

  // MARK: - Initializers

  public init(list: L, displayingSection: Int) {
    self.updater = SectionUpdater(list: list)
    self.displayingSection = displayingSection
  }

  // MARK: - Functions

  public func numberOfItems() -> Int {
    return items.count
  }

  public func item(for indexPath: IndexPath) -> T {
    let index = toIndex(from: indexPath)
    return items[index]
  }

  public func update(items: [T], updatePartially: Bool, completion: @escaping () -> Void) {
    // FIXME:
  }

  @inline(__always)
  private func toIndex(from indexPath: IndexPath) -> Int {
    assert(indexPath.section == displayingSection, "IndexPath.section (\(indexPath.section)) must be equal to displayingSection (\(displayingSection)).")
    return indexPath.item
  }
}
