//
//  DataSources.swift
//  DataSources
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

#if !COCOAPODS
  @_exported import ListDiff
#endif

@inline(__always)
func assertMainThread() {
  assert(Thread.isMainThread, "You must call on MainThread")
}
