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

final class AnySectionDataSource<A: Updating> {

  let source: Any

  private let _numberOfItems: () -> Int
  private let _item: (IndexPath) -> Any
  
  init<T>(source: SectionDataSource<T, A>) {
    self.source = source
    _numberOfItems = {
      source.numberOfItems()
    }
    _item = {
      let index = source.toIndex(from: $0)
      return source.snapshot[index]
    }
  }

  public func numberOfItems() -> Int {
    return _numberOfItems()
  }

  public func item(for indexPath: IndexPath) -> Any {
    return _item(indexPath)
  }

  func restore<T>(itemType: T.Type) -> SectionDataSource<T, A> {
    guard let r = source as? SectionDataSource<T, A> else {
      fatalError("itemType is different to SectionDataSource.ItemType")
    }
    return r
  }
}

public final class SectionDataSource<T: Diffable, A: Updating>: SectionDataSourceType {

  public typealias ItemType = T
  public typealias AdapterType = A

  public enum UpdateMode {
    case everything
    case partial(animated: Bool)
  }

  // MARK: - Properties

  private(set) public var items: [T] = []

  fileprivate var snapshot: [T] = []

  private let updater: SectionUpdater<T, A>

  private let throttle = Throttle(interval: 0.2)

  public var displayingSection: Int

  fileprivate let isEqual: (T, T) -> Bool

  // MARK: - Initializers

  public init(adapter: A, displayingSection: Int = 0, isEqual: @escaping EqualityChecker<T>) {
    self.updater = SectionUpdater(adapter: adapter)
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

    self.items = items

    throttle.on { [weak self] in
      guard let `self` = self else { return }

      let old = self.snapshot
      let new = self.items
      self.snapshot = new

      var _updateMode: SectionUpdater<T, A>.UpdateMode {
        switch updateMode {
        case .everything:
          return .everything
        case .partial(let animated):
          return .partial(animated: animated, isEqual: self.isEqual)
        }
      }

      self.updater.update(
        targetSection: self.displayingSection,
        currentDisplayingItems: old,
        newItems: new,
        updateMode: _updateMode,
        completion: completion
      )
    }
  }

  public func asSectionDataSource() -> SectionDataSource<ItemType, AdapterType> {
    return self
  }

  @inline(__always)
  fileprivate func toIndex(from indexPath: IndexPath) -> Int {
    assert(indexPath.section == displayingSection, "IndexPath.section (\(indexPath.section)) must be equal to displayingSection (\(displayingSection)).")
    return indexPath.item
  }
}

extension SectionDataSource {

  public func indexPath(of item: T) -> IndexPath {
    let index = items.index(where: { isEqual($0, item) })!
    return IndexPath(item: index, section: displayingSection)
  }
}

extension SectionDataSource where T : AnyObject {

  public func indexPathPointerPersonality(of item: T) -> IndexPath {
    let index = items.index(where: { $0 === item })!
    return IndexPath(item: index, section: displayingSection)
  }
}

extension SectionDataSource where T : Equatable {

  public convenience init(adapter: A, displayingSection: Int = 0) {
    self.init(adapter: adapter, displayingSection: displayingSection, isEqual: { a, b in a == b })
  }
}
