//
//  DataSource.swift
//  DataSources
//
//  Created by muukii on 8/9/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public final class DataSource<A: Updating> {

  let adapter: A

  private(set) public var numberOfSections: Int = 0

  public init(adapter: A) {
    self.adapter = adapter
  }

  public func sectionDataSource<T: Diffable>(_ itemType: T.Type, isEqual: @escaping EqualityChecker<T>) -> SectionDataSource<T, A> {
    assertMainThread()
    numberOfSections += 1
    return SectionDataSource<T, A>(adapter: adapter, displayingSection: numberOfSections, isEqual: isEqual)
  }
}
