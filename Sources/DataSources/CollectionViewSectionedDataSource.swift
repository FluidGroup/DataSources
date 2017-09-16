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

  public let dataController: DataController<CollectionViewAdapter>

  public var supplementaryViewFactory: SupplementaryViewFactory = { _, _, _, _ in fatalError("You must set supplementaryViewFactory") } {
    didSet {

    }
  }

  private var handlers: [DataController<CollectionViewAdapter>.Handler<UICollectionViewCell>] = []

  public init(dataSource: DataController<CollectionViewAdapter>) {
    self.dataController = dataSource
  }

  public func set(handlers: [DataController<CollectionViewAdapter>.Handler<UICollectionViewCell>]) {
    self.handlers = handlers
  }

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return dataController.numberOfSections()
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataController.numberOfItems(in: section)
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    return dataController.item(at: indexPath, returnType: UICollectionViewCell.self, handlers: handlers)
  }

  public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    return supplementaryViewFactory(self, collectionView, kind, indexPath)
  }
}
