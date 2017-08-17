//
//  Foundation+Diffable.swift
//  Diff
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

extension Int: Diffable {
  public var diffIdentifier: Int {
    return self
  }
}

extension NSNumber: Diffable {
  public var diffIdentifier: NSNumber {
    return self
  }
}

extension String: Diffable {
  public var diffIdentifier: String {
    return self
  }
}

extension NSString: Diffable {
  public var diffIdentifier: NSString {
    return self
  }
}

extension FloatingPoint {

  public var diffIdentifier: Self {
    return self
  }
}

extension Float : Diffable {

}

extension Double : Diffable {

}
