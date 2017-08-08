//
//  Foundation+Diffable.swift
//  Diff
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

extension Int: Diffable {
  public var diffIdentifier: AnyHashable {
    return .init(self)
  }
}

extension NSNumber: Diffable {
  public var diffIdentifier: AnyHashable {
    return .init(self)
  }
}

extension String: Diffable {
  public var diffIdentifier: AnyHashable {
    return .init(self)
  }
}

extension NSString: Diffable {
  public var diffIdentifier: AnyHashable {
    return .init(self)
  }
}
