//
//  DataSource.swift
//  ListAdapter
//
//  Created by muukii on 8/7/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public final class DataSource<T: Diffable> {

  public var items: [T] = []

  public var snapshot: [T]?

  public init() {

  }
}
