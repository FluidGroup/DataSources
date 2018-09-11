//
//  CollectionViewDataSource.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/20/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

public final class CollectionViewDataSource<T: Diffable> : NSObject, UICollectionViewDataSource {

  public typealias CellFactory = (CollectionViewDataSource, UICollectionView, IndexPath, T) -> UICollectionViewCell
  public typealias SupplementaryViewFactory = (CollectionViewDataSource, UICollectionView, String, IndexPath) -> UICollectionReusableView

  public let sectionDataController: SectionDataController<T, CollectionViewAdapter>

  public var supplementaryViewFactory: SupplementaryViewFactory = { _, _, _, _ in fatalError("You must set supplementaryViewFactory") } {
    didSet {

    }
  }

  public var cellFactory: CellFactory = { _, _, _, _ in fatalError("You must set cellFactory") } {
    didSet {

    }
  }

  public init(sectionDataSource: SectionDataController<T, CollectionViewAdapter>) {
    self.sectionDataController = sectionDataSource
  }

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sectionDataController.numberOfItems()
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return cellFactory(self, collectionView, indexPath, sectionDataController.item(at: indexPath)!)
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return supplementaryViewFactory(self, collectionView, kind, indexPath)
  }
}
