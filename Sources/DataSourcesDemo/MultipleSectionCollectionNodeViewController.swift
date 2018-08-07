//
//  MultipleSectionCollectionNodeViewController.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/11/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import DataSources
import EasyPeasy
import RxSwift
import RxCocoa
import AsyncDisplayKit

final class MultipleSectionCollectionNodeViewController: UIViewController, ASCollectionDataSource, ASCollectionDelegateFlowLayout {

  private lazy var collectionNode: ASCollectionNode = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = .zero
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    return ASCollectionNode(collectionViewLayout: layout)
  }()

  private lazy var _dataSource: DataController<CollectionNodeAdapter> = .init(adapter: .init(collectionNode: self.collectionNode))

  private let section0 = Section(ModelA.self)
  private let section1 = Section(ModelB.self)

  private let add = UIBarButtonItem(title: "Add", style: .plain, target: nil, action: nil)
  private let remove = UIBarButtonItem(title: "Remove", style: .plain, target: nil, action: nil)
  private let addRemove = UIBarButtonItem(title: "AddRemove", style: .plain, target: nil, action: nil)
  private let shuffle = UIBarButtonItem(title: "Shuffle", style: .plain, target: nil, action: nil)

  private let viewModel = ViewModel()
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubnode(collectionNode)
    collectionNode.view <- Edges()

    navigationItem.rightBarButtonItems = [add, remove, addRemove, shuffle]

    add.rx.tap
      .bind(onNext: viewModel.add)
      .disposed(by: disposeBag)

    remove.rx.tap
      .bind(onNext: viewModel.remove)
      .disposed(by: disposeBag)

    addRemove.rx.tap
      .bind(onNext: viewModel.addRemove)
      .disposed(by: disposeBag)

    shuffle.rx.tap
      .bind(onNext: viewModel.shuffle)
      .disposed(by: disposeBag)

    collectionNode.delegate = self
    collectionNode.dataSource = self

    _dataSource.add(section: section0)
    _dataSource.add(section: section1)

    viewModel.section0
      .asDriver()
      .drive(onNext: { [unowned self] items in

        self._dataSource.update(in: self.section0, items: items, updateMode: .partial(animated: true), completion: {

        })
      })
      .disposed(by: disposeBag)

    viewModel.section1
      .asDriver()
      .drive(onNext: { [unowned self] items in
        self._dataSource.update(in: self.section1, items: items, updateMode: .partial(animated: true), completion: {

        })
      })
      .disposed(by: disposeBag)
  }

  func numberOfSections(in collectionNode: ASCollectionNode) -> Int {
    return _dataSource.numberOfSections()
  }

  func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
    return _dataSource.numberOfItems(in: section)
  }

  func collectionNode(_ collectionNode: ASCollectionNode, nodeBlockForItemAt indexPath: IndexPath) -> ASCellNodeBlock {
    return _dataSource.item(
      at: indexPath,
      handlers: [
        .init(section: section0) { _, _, m in
          {
            CellNode(model: m)
          }
        },
        .init(section: section1) { _, _, m in
          {
            CellNode(model: m)
          }
        },
        ])
  }

  func collectionNode(_ collectionNode: ASCollectionNode, constrainedSizeForItemAt indexPath: IndexPath) -> ASSizeRange {
    return
      ASSizeRange(
        min: CGSize(width: collectionNode.bounds.width / 6, height: 50),
        max: CGSize(width: collectionNode.bounds.width / 6, height: 50)
    )
  }
}
