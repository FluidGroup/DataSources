//
//  DiffTests.swift
//  DiffTests
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import XCTest
@testable import Diff

final class DiffTests: XCTestCase {

  final class SwiftClass: Diffable, Equatable {

    static func == (lhs: SwiftClass, rhs: SwiftClass) -> Bool {
      guard lhs.id == rhs.id else { return false }
      guard lhs.id == rhs.id else { return false }
      return true
    }

    let id: Int
    let value: String

    init(id: Int, value: String) {
      self.id = id
      self.value = value
    }

    var diffIdentifier: AnyHashable {
      return .init(id)
    }
  }

  final class SwiftStruct: Diffable, Equatable {

    static func == (lhs: SwiftStruct, rhs: SwiftStruct) -> Bool {
      guard lhs.id == rhs.id else { return false }
      guard lhs.id == rhs.id else { return false }
      return true
    }

    let id: Int
    let value: String

    init(id: Int, value: String) {
      self.id = id
      self.value = value
    }

    var diffIdentifier: AnyHashable {
      return .init(id)
    }
  }

  func testDiffingNSStrings() {
    let o: [NSString] = ["a", "b", "c"]
    let n: [NSString] = ["a", "c", "d"]
    let result = Diff.diffing(oldArray: o, newArray: n, isEqual: { a, b in a == b })
    XCTAssertEqual(result.deletes, IndexSet(integer: 1))
    XCTAssertEqual(result.inserts, IndexSet(integer: 2))
    XCTAssertEqual(result.moves.count, 0)
    XCTAssertEqual(result.updates.count, 0)
  }

  func testDiffingNumbers() {
    let o: [NSNumber] = [0, 1, 2]
    let n: [NSNumber] = [0, 2, 4]
    let result =  Diff.diffing(oldArray: o, newArray: n, isEqual: { a, b in a == b })
    XCTAssertEqual(result.deletes, IndexSet(integer: 1))
    XCTAssertEqual(result.inserts, IndexSet(integer: 2))
    XCTAssertEqual(result.moves.count, 0)
    XCTAssertEqual(result.updates.count, 0)
  }

  func testDiffingSwiftClass() {
    let o = [SwiftClass(id: 0, value: "a"), SwiftClass(id: 1, value: "b"), SwiftClass(id: 2, value: "c")]
    let n = [SwiftClass(id: 0, value: "a"), SwiftClass(id: 2, value: "c"), SwiftClass(id: 4, value: "d")]
    let result =  Diff.diffing(oldArray: o, newArray: n, isEqual: { a, b in a == b })
    XCTAssertEqual(result.deletes, IndexSet(integer: 1))
    XCTAssertEqual(result.inserts, IndexSet(integer: 2))
    XCTAssertEqual(result.moves.count, 0)
    XCTAssertEqual(result.updates.count, 0)
  }

  func testDiffingSwiftStruct() {
    let o = [SwiftStruct(id: 0, value: "a"), SwiftStruct(id: 1, value: "b"), SwiftStruct(id: 2, value: "c")]
    let n = [SwiftStruct(id: 0, value: "a"), SwiftStruct(id: 2, value: "c"), SwiftStruct(id: 4, value: "d")]
    let result =  Diff.diffing(oldArray: o, newArray: n, isEqual: { a, b in a == b })
    XCTAssertEqual(result.deletes, IndexSet(integer: 1))
    XCTAssertEqual(result.inserts, IndexSet(integer: 2))
    XCTAssertEqual(result.moves.count, 0)
    XCTAssertEqual(result.updates.count, 0)
  }
}
