//
//  SectionDataSource.swift
//  ListAdapter
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public protocol SectionDataSourceType {

  associatedtype ItemType : Diffable
  associatedtype AdapterType : Updating

  func update(items: [ItemType], updateMode: SectionDataSource<ItemType, AdapterType>.UpdateMode, completion: @escaping () -> Void)

  func asSectionDataSource() -> SectionDataSource<ItemType, AdapterType>
}

public final class SectionDataSource<T: Diffable, L: Updating>: SectionDataSourceType {

  public typealias ItemType = T
  public typealias AdapterType = L

  public enum UpdateMode {
    case everything
    case partial(animated: Bool)
  }

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

  public func update(items: [T], updateMode: UpdateMode, completion: @escaping () -> Void) {

    let old = snapshot
    snapshot = items

    var _updateMode: SectionUpdater<T, L>.UpdateMode {
      switch updateMode {
      case .everything:
        return .everything
      case .partial(let animated):
        return .partial(animated: animated, isEqual: isEqual)
      }
    }

    updater.update(
      targetSection: displayingSection,
      currentDisplayingItems: old,
      newItems: items,
      updateMode: _updateMode,
      completion: completion
    )
  }

  // Exp
  func update(mutate: (inout ChangesCollection<T>), updatePartially: Bool, completion: @escaping () -> Void) {
    // FIXME:
  }

  public func asSectionDataSource() -> SectionDataSource<ItemType, AdapterType> {
    return self
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
