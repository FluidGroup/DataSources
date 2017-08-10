//
//  DataSource.swift
//  DataSources
//
//  Created by muukii on 8/9/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public func ~= <T>(lhs: Section<T>, rhs: Int) -> Bool {
  switch lhs.state {
  case .initialized:
    return false
  case .added(let section):
    return section == rhs
  }
}

public class Section<T: Diffable> {

  public enum State {
    case initialized
    case added(at: Int)
  }

  public let isEqual: EqualityChecker<T>
  public internal(set) var state: State = .initialized

  public init(_ itemType: T.Type? = nil, isEqual: @escaping EqualityChecker<T>) {
    self.isEqual = isEqual
  }
}

extension Section where T : Equatable {

  public convenience init(_ itemType: T.Type? = nil) {
    self.init(itemType, isEqual: { $0 == $1 })
  }
}

public final class DataSource<A: Updating> {

  public struct Handler<U> {

    let handler: (Any) -> U
    let section: Int

    public init<T>(section: Section<T>, handler: @escaping (T) -> U) {

      switch section.state {
      case .initialized:
        fatalError("\(section) is not added in DataSource")
      case .added(let section):
        self.section = section
        self.handler = {
          return handler($0 as! T)
        }
      }
    }
  }

  public typealias SectionNumber = Int

  let adapter: A

  private var sectionDataSources: [SectionNumber : AnySectionDataSource<A>] = [:]

  public init(adapter: A) {
    assertMainThread()
    self.adapter = adapter
  }

  public func add<T>(section: Section<T>) {
    assertMainThread()

    let _section = sectionDataSources.count
    section.state = .added(at: _section)

    let source = SectionDataSource<T, A>(adapter: adapter, displayingSection: _section, isEqual: section.isEqual)
    precondition(sectionDataSources[_section] == nil, "Duplicated section \(_section)")

    if _section > 0 {
      precondition(sectionDataSources[_section - 1] != nil, "Section \(_section - 1) is empty, You must add section without gaps.")
    }

    sectionDataSources[_section] = AnySectionDataSource(source: source)
  }

  public func numberOfSections() -> Int {
    assertMainThread()
    return sectionDataSources.count
  }

  public func numberOfItems(in section: SectionNumber) -> Int {
    assertMainThread()
    return sectionDataSources[section]!.numberOfItems()
  }

  public func item<T>(at indexPath: IndexPath, in section: Section<T>) -> T {
    assertMainThread()
    guard case .added = section.state else {
      fatalError("\(section) has not added in DataSource")
    }
    return sectionDataSource(section: section).item(at: indexPath)
  }

  public func update<T>(in section: Section<T>, items: [T], updateMode: SectionDataSource<T, A>.UpdateMode, completion: @escaping () -> Void) {

    assertMainThread()

    sectionDataSource(section: section)
      .update(
        items: items,
        updateMode: updateMode,
        completion: completion
    )
  }

  public func sectionDataSource<T>(section: Section<T>) -> SectionDataSource<T, A> {

    assertMainThread()

    guard case .added(let sectionNumber) = section.state else {
      fatalError("\(section) has not added in DataSource")
    }

    guard let s = sectionDataSources[sectionNumber]?.restore(itemType: T.self) else {
      fatalError("oh")
    }
    return s
  }

  public func item<U>(at indexPath: IndexPath, returnType: U.Type? = nil, handlers: [Handler<U>]) -> U {

    assertMainThread()

    let r = handlers.filter { $0.section == indexPath.section }
    precondition(r.count == 1, "Handler has duplicated in the section \(indexPath.section). You must register only one the handler for each section.")
    guard let handler = r.first else {
      fatalError("Section \(indexPath.section) was not caught by every handler. You must register the handler for all sections.")
    }

    guard let s = sectionDataSources[handler.section]?.item(for: indexPath) else {
      fatalError("")
    }

    return handler.handler(s)
  }
}
