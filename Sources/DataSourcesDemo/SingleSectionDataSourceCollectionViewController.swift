//
//  SingleSectionDataSourceCollectionViewController.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/20/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import DataSources
import EasyPeasy
import RxSwift
import RxCocoa

final class SingleSectionDataSourceCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = .zero
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.backgroundColor = .white
    return collectionView
  }()

  private lazy var _dataSource: SectionDataController<ModelA, CollectionViewAdapter> = .init(
    adapter: .init(collectionView: self.collectionView),
    displayingSection: 0
  )

  private lazy var dataSource: CollectionViewDataSource<ModelA> = .init(sectionDataSource: self._dataSource)

  private let add = UIBarButtonItem(title: "Add", style: .plain, target: nil, action: nil)
  private let remove = UIBarButtonItem(title: "Remove", style: .plain, target: nil, action: nil)
  private let addRemove = UIBarButtonItem(title: "AddRemove", style: .plain, target: nil, action: nil)
  private let shuffle = UIBarButtonItem(title: "Shuffle", style: .plain, target: nil, action: nil)

  private let viewModel = ViewModel()
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    collectionView <- Edges()

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

    collectionView.delegate = self
    collectionView.dataSource = dataSource

    dataSource.cellFactory = { _, collectionView, indexPath, m in
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
      cell.label.text = m.title
      return cell
    }

    viewModel.section0
      .asDriver()
      .drive(onNext: { [weak self] items in
        print("Begin update")
        self?._dataSource.update(items: items, updateMode: .partial(animated: true), completion: {
          print("Throttled Complete")
        })
      })
      .disposed(by: disposeBag)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: collectionView.bounds.width / 6, height: 50)
  }
}
