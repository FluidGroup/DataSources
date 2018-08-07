//
//  Deprecated.swift
//  DataSources
//
//  Created by muukii on 8/21/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import DifferenceKit

@available(*, deprecated: 0.3.0, renamed: "SectionDataController")
public typealias SectionDataSource<A: Differentiable, B: Updating> = SectionDataController<A, B>

@available(*, deprecated: 0.3.0, renamed: "DataSource")
public typealias DataSource<A: Updating> = DataController<A>
