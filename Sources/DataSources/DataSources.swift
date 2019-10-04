//
//  DataSources.swift
//  DataSources
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

@_exported import DifferenceKit

@inline(__always)
func assertMainThread() {
  assert(Thread.isMainThread, "You must call on MainThread")
}
