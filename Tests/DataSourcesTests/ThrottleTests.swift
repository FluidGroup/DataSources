//
//  ThrottleTests.swift
//  DataSources
//
//  Created by muukii on 8/9/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import XCTest

@testable import DataSources

final class ThrottleTests : XCTestCase {

  func testThrottle() {

    let token = expectation(description: "wait")

    var count = 0

    let t = Throttle(interval: 0.5)

    t.on {
      count += 1
    }

    let now: DispatchTime = .now()

    for i in stride(from: 0.0, to: 2.0, by: 0.1) {
      DispatchQueue.main.asyncAfter(deadline: now + i) {
        t.on {
          count += 1
        }
      }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      XCTAssertEqual(count, 4)
      token.fulfill()
    }

    waitForExpectations(timeout: 4, handler: nil)

  }
}
