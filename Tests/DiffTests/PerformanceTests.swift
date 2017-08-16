//
//  PerformanceTests.swift
//  DiffTests
//
//  Created by muukii on 8/17/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import XCTest
@testable import Diff

final class PerformanceTests: XCTestCase {

  func testBasicDiff() {

    let o: [Int] = [1,2,3,4,5,6,7,8,9]
    let n: [Int] = [1,2,4,5,6,3,7,9]
    measure {
      _ = Diff.diffing(oldArray: o, newArray: n, isEqual: { a, b in a == b })
    }
  }

  func testLargeCollection() {

    let o: [Int] = Array((0..<10000).map { $0 })
    let n: [Int] = Array((0..<10000).map { $0 }.filter { $0 % 2 == 0 })
    measure {
      _ = Diff.diffing(oldArray: o, newArray: n, isEqual: { a, b in a == b })
    }
  }
}
