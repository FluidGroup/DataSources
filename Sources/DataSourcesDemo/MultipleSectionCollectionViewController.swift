//
//  CollectionViewController.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import DataSources
import EasyPeasy
import RxSwift
import RxCocoa

final class MultipleSectionCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = .zero
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "Header")
    collectionView.backgroundColor = .white
    return collectionView
  }()

  private lazy var _dataSource = DataSource<CollectionViewAdapter>.init(adapter: .init(collectionView: self.collectionView))

  private let section0 = Section(ModelA.self, isEqual: { $0.identity == $1.identity })
  private let section1 = Section(ModelB.self, isEqual: { $0.identity == $1.identity })

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
    collectionView.dataSource = self

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

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return _dataSource.numberOfSections()
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return _dataSource.numberOfItems(in: section)
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    return _dataSource.item(
      at: indexPath,
      returnType: UICollectionViewCell.self,
      handlers: [
      .init(section: section0) { m in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = m.title
        return cell
      },
      .init(section: section1) { m in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = m.title
        return cell
        },
      ])

    /* Other way
    switch indexPath.section {
    case section0:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
      let m = _dataSource.item(at: indexPath, in: section0)
      cell.label.text = m.title
      return cell
    case section1:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
      let m = _dataSource.item(at: indexPath, in: section1)
      cell.label.text = m.title
      return cell
    default:
      fatalError()
    }
     */
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    if kind == UICollectionElementKindSectionHeader {
      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! Header
      view.label.text = "Section " + indexPath.section.description
      return view
    }
    fatalError()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

    return CGSize(width: collectionView.bounds.width, height: 50)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: collectionView.bounds.width / 6, height: 50)
  }
}
