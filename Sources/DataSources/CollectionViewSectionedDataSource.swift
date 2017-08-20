//
//  CollectionViewDataSource.swift
//  DataSources
//
//  Created by muukii on 8/20/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

public final class CollectionViewSectionedDataSource : NSObject, UICollectionViewDataSource {

  public typealias SupplementaryViewFactory = (CollectionViewSectionedDataSource, UICollectionView, String, IndexPath) -> UICollectionReusableView

  public let dataSource: DataSource<CollectionViewAdapter>

  public var supplementaryViewFactory: SupplementaryViewFactory = { _ in fatalError("You must set supplementaryViewFactory") } {
    didSet {

    }
  }

  private var handlers: [DataSource<CollectionViewAdapter>.Handler<UICollectionViewCell>] = []

  public init(dataSource: DataSource<CollectionViewAdapter>) {
    self.dataSource = dataSource
  }

  public func set(handlers: [DataSource<CollectionViewAdapter>.Handler<UICollectionViewCell>]) {
    self.handlers = handlers
  }

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataSource.numberOfSections()
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.numberOfItems(in: section)
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return dataSource.item(at: indexPath, returnType: UICollectionViewCell.self, handlers: handlers)
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return supplementaryViewFactory(self, collectionView, kind, indexPath)
  }
}
