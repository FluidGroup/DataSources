
import Foundation

import DifferenceKit

public struct IndexPathDiff: Sendable {

  public struct Move : Sendable {
    let from: IndexPath
    let to: IndexPath
  }

  public let inserts: [IndexPath]

  public let updates: [IndexPath]

  public let deletes: [IndexPath]

  public let moves: [Move]

  init<T>(diff: Changeset<T>, targetSection: Int) {
    self.updates = diff.elementUpdated.map { IndexPath(item: $0.element, section: targetSection) }
    self.inserts = diff.elementInserted.map { IndexPath(item: $0.element, section: targetSection) }
    self.deletes = diff.elementDeleted.map { IndexPath(item: $0.element, section: targetSection) }
    self.moves = diff.elementMoved.map {
      Move(
        from: IndexPath(item: $0.source.element, section: targetSection),
        to: IndexPath(item: $0.target.element, section: targetSection)
      )
    }
  }
}

public struct UpdateContext<Element> {

  public let diff: IndexPathDiff
  public let snapshot: [Element]

  init(
    diff: IndexPathDiff,
    snapshot: [Element]
    ) {

    self.diff = diff
    self.snapshot = snapshot
  }
}

extension UpdateContext: Sendable where Element: Sendable {
}


public protocol Updating: ~Copyable, Sendable {

  associatedtype Target
  associatedtype Element
  
  var target: Target { get }

  @MainActor
  func insertItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>)

  @MainActor
  func deleteItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>)

  @MainActor
  func reloadItems(at indexPaths: [IndexPath], in context: UpdateContext<Element>)

  @MainActor
  func moveItem(at indexPath: IndexPath, to newIndexPath: IndexPath, in context: UpdateContext<Element>)

  @MainActor
  func performBatch(in context: UpdateContext<Element>, animated: Bool, updates: @escaping () -> Void, completion: @escaping () -> Void)

  @MainActor
  func reload(completion: @escaping () -> Void)
}
