//
//  CollectionViewDataSource.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/20/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

public final class CollectionViewDataSource<T: Diffable> : NSObject, UICollectionViewDataSource {

  public typealias CellFactory = (CollectionViewDataSource, UICollectionView, IndexPath, T) -> UICollectionViewCell
  public typealias SupplementaryViewFactory = (CollectionViewDataSource, UICollectionView, String, IndexPath) -> UICollectionReusableView

  public let sectionDataSource: SectionDataSource<T, CollectionViewAdapter>

  public var supplementaryViewFactory: SupplementaryViewFactory = { _ in fatalError("You must set supplementaryViewFactory") } {
    didSet {

    }
  }

  public var cellFactory: CellFactory = { _ in fatalError("You must set cellFactory") } {
    didSet {

    }
  }

  public init(sectionDataSource: SectionDataSource<T, CollectionViewAdapter>) {
    self.sectionDataSource = sectionDataSource
  }

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sectionDataSource.numberOfItems()
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return cellFactory(self, collectionView, indexPath, sectionDataSource.item(at: indexPath))
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return supplementaryViewFactory(self, collectionView, kind, indexPath)
  }
}
