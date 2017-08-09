//
//  DataSource.swift
//  DataSources
//
//  Created by muukii on 8/9/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public func ~= <T>(lhs: SectionContext<T>, rhs: Int) -> Bool {
  return lhs.section == rhs
}

public struct SectionContext<T: Diffable> {

  public let section: Int
  public let isEqual: EqualityChecker<T>

  public init(_ itemType: T.Type? = nil, section: Int, isEqual: @escaping EqualityChecker<T>) {
    self.section = section
    self.isEqual = isEqual
  }
}

extension SectionContext where T : Equatable {

  public init(_ itemType: T.Type? = nil, section: Int) {
    self.section = section
    self.isEqual = { $0 == $1 }
  }
}

public final class DataSource<A: Updating> {

  public struct Handler<U> {

    let handler: (Any) -> U
    let section: Int

    public init<T>(context: SectionContext<T>, handler: @escaping (T) -> U) {
      self.section = context.section
      self.handler = {
        return handler($0 as! T)
      }
    }
  }

  public typealias Section = Int

  let adapter: A

  private var sectionDataSources: [Section : AnySectionDataSource<A>] = [:]

  public init(adapter: A) {
    assertMainThread()
    self.adapter = adapter
  }

  public func addSectionDataSource<T>(context: SectionContext<T>) {
    assertMainThread()
    let source = SectionDataSource<T, A>(adapter: adapter, displayingSection: context.section, isEqual: context.isEqual)
    precondition(sectionDataSources[context.section] == nil, "Duplicated section \(context.section)")

    if context.section > 0 {
      precondition(sectionDataSources[context.section - 1] != nil, "Section \(context.section - 1) is empty, You must add section without gaps.")
    }

    sectionDataSources[context.section] = AnySectionDataSource(source: source)
  }

  public func numberOfSections() -> Int {
    assertMainThread()
    return sectionDataSources.count
  }

  public func numberOfItems(in section: Section) -> Int {
    assertMainThread()
    return sectionDataSources[section]!.numberOfItems()
  }

  public func item<T>(at indexPath: IndexPath, in context: SectionContext<T>) -> T {
    assertMainThread()
    precondition(indexPath.section == context.section)
    return sectionDataSource(context: context).item(for: indexPath)
  }

  public func update<T>(in context: SectionContext<T>, items: [T], updateMode: SectionDataSource<T, A>.UpdateMode, completion: @escaping () -> Void) {

    assertMainThread()

    sectionDataSource(context: context)
      .update(
        items: items,
        updateMode: updateMode,
        completion: completion
    )
  }

  public func sectionDataSource<T>(context: SectionContext<T>) -> SectionDataSource<T, A> {

    assertMainThread()

    guard let s = sectionDataSources[context.section]?.restore(itemType: T.self) else {
      fatalError()
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
