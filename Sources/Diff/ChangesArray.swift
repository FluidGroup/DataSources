//
//  ChangesArray.swift
//  Diff
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

// WIP
public struct ChangesCollection<T: Diffable> {

  private(set) public var source: [T]
  private(set) public var result: DiffResult = .init()

  public init(source: [T]) {
    self.source = source
  }

  public mutating func append(_ newElement: T) {
    let i: Array<T>.Index = source.count
    source.append(newElement)
    result.inserts.insert(i)
  }

  public mutating func remove(at index: Int) -> T {
    result.deletes.insert(index)
    return source.remove(at: index)
  }

  public mutating func removeFirst() -> T {

    return source.removeFirst()
  }
}
