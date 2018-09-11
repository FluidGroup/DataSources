//
//  SectionDataController.swift
//  DataSources
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public protocol SectionDataControllerType {

  associatedtype ItemType : Diffable
  associatedtype AdapterType : Updating

  func update(items: [ItemType], updateMode: SectionDataController<ItemType, AdapterType>.UpdateMode, immediately: Bool, completion: @escaping () -> Void)

  func asSectionDataController() -> SectionDataController<ItemType, AdapterType>
}

/// Type of Model erased SectionDataController
final class AnySectionDataController<A: Updating> {

  let source: Any

  private let _numberOfItems: () -> Int
  private let _item: (IndexPath) -> Any?
  
  init<T>(source: SectionDataController<T, A>) {
    self.source = source
    _numberOfItems = {
      source.numberOfItems()
    }
    _item = {
      guard let index = source.toIndex(from: $0) else { return nil }
      return source.snapshot[index]
    }
  }

  public func numberOfItems() -> Int {
    return _numberOfItems()
  }

  public func item(for indexPath: IndexPath) -> Any? {
    return _item(indexPath)
  }

  func restore<T>(itemType: T.Type) -> SectionDataController<T, A> {
    guard let r = source as? SectionDataController<T, A> else {
      fatalError("itemType is different to SectionDataSource.ItemType")
    }
    return r
  }
}

/// DataSource for a section
public final class SectionDataController<T: Diffable, A: Updating>: SectionDataControllerType {

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

  private let throttle = Throttle(interval: 0.1)

  public var displayingSection: Int

  fileprivate let isEqual: (T, T) -> Bool

  // MARK: - Initializers

  /// Initialize
  ///
  /// - Parameters:
  ///   - itemType:
  ///   - adapter:
  ///   - displayingSection:
  ///   - isEqual: To use for decision that item should update.
  public init(itemType: T.Type? = nil, adapter: A, displayingSection: Int = 0, isEqual: @escaping EqualityChecker<T>) {
    self.updater = SectionUpdater(adapter: adapter)
    self.isEqual = isEqual
    self.displayingSection = displayingSection
  }

  // MARK: - Functions

  /// Return number of items based on snapshot
  ///
  /// - Returns:
  public func numberOfItems() -> Int {
    return snapshot.count
  }

  /// Return item based on snapshot
  ///
  /// - Returns:
  public func item(at indexPath: IndexPath) -> T? {
    guard let index = toIndex(from: indexPath) else { return nil }
    return snapshot[index]
  }

  /// Reserves that a move occurred in DataSource by View operation.
  ///
  /// If you moved item on View, operation following order,
  /// 1. Call reserveMoved(...
  /// 2. Reorder items
  /// 3. update(items: [T]..
  ///
  /// - Parameters:
  ///   - sourceIndexPath:
  ///   - destinationIndexPath:
  public func reserveMoved(source sourceIndexPath: IndexPath, destination destinationIndexPath: IndexPath) {

    precondition(
      sourceIndexPath.section == displayingSection,
      "sourceIndexPath.section \(sourceIndexPath.section) must be equal to \(displayingSection)"
    )
    precondition(
      destinationIndexPath.section == displayingSection,
      "destinationIndexPath.section \(sourceIndexPath.section) must be equal to \(displayingSection)"
    )

    let o = snapshot.remove(at: sourceIndexPath.item)
    snapshot.insert(o, at: destinationIndexPath.item)
  }

  /// Update
  ///
  /// In default, Calling `update` will be throttled.
  /// If you want to update immediately, set true to `immediately`.
  ///
  /// - Parameters:
  ///   - items:
  ///   - updateMode:
  ///   - immediately: False : indicate to throttled updating
  ///   - completion: 
  public func update(
    items: [T],
    updateMode: UpdateMode,
    immediately: Bool = false,
    completion: @escaping () -> Void
    ) {

    self.items = items

    let task = { [weak self] in
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

    if immediately {
      throttle.cancel()
      task()
    } else {
      throttle.on {
        task()
      }
    }
  }

  public func asSectionDataController() -> SectionDataController<ItemType, AdapterType> {
    return self
  }

  /// Create IndexPath from item and displayingSection.
  ///
  /// - Parameter item:
  /// - Returns:
  public func indexPath(item: Int) -> IndexPath {
    return IndexPath(item: item, section: displayingSection)
  }

  @inline(__always)
  fileprivate func toIndex(from indexPath: IndexPath) -> Int? {
    guard indexPath.section == displayingSection else {
      assertionFailure("IndexPath.section (\(indexPath.section)) must be equal to displayingSection (\(displayingSection)).")
      return nil
    }
    return indexPath.item
  }
}

extension SectionDataController {

  /// IndexPath of Item
  ///
  /// IndexPath will be found by isEqual closure.
  ///
  /// - Parameter item:
  /// - Returns:
  public func indexPath(of item: T) -> IndexPath? {
    guard let index = items.index(where: { isEqual($0, item) }) else { return nil }
    return IndexPath(item: index, section: displayingSection)
  }

  public func indexPath(of `where`: (T) -> Bool) -> IndexPath? {
    guard let index = items.index(where:`where`) else { return nil }
    return IndexPath(item: index, section: displayingSection)
  }
}

extension SectionDataController where T : AnyObject {

  /// IndexPath of Item
  ///
  /// IndexPath will be found by the pointer for Item.
  ///
  /// - Parameter item:
  /// - Returns:
  public func indexPathPointerPersonality(of item: T) -> IndexPath? {
    guard let index = items.index(where: { $0 === item }) else { return nil }
    return IndexPath(item: index, section: displayingSection)
  }
}

extension SectionDataController where T : Equatable {

  public convenience init(itemType: T.Type? = nil, adapter: A, displayingSection: Int = 0) {
    self.init(adapter: adapter, displayingSection: displayingSection, isEqual: { a, b in a == b })
  }
}
