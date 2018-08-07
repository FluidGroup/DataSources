//
//  MultipleSectionSectionedDataSourceCollectionViewController.swift
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

final class MultipleSectionSectionedDataSourceCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout {

  private lazy var collectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = .zero
    layout.minimumLineSpacing = 0
    layout.minimumInteritemSpacing = 0

    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
    collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
    collectionView.backgroundColor = .white
    return collectionView
  }()

  private lazy var _dataController: DataController<CollectionViewAdapter> = .init(adapter: .init(collectionView: self.collectionView))

  private lazy var dataSource: CollectionViewSectionedDataSource = CollectionViewSectionedDataSource(dataSource: self._dataController)

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

    view.addSubview(collectionView)
    collectionView.easy.layout(Edges())

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

    _dataController.add(section: section0)
    _dataController.add(section: section1)

    dataSource.set(handlers: [
      .init(section: section0) { collectionView, indexPath, m in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = m.title
        return cell
      },
      .init(section: section1) { collectionView, indexPath, m in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.label.text = m.title
        return cell
      },
      ])

    dataSource.supplementaryViewFactory = { _, collectionView, kind, indexPath in
      if kind == UICollectionView.elementKindSectionHeader {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! Header
        view.label.text = "Section " + indexPath.section.description
        return view
      }
      fatalError()
    }

    viewModel.section0
      .asDriver()
      .drive(onNext: { [unowned self] items in

        self._dataController.update(in: self.section0, items: items, updateMode: .partial(animated: true), completion: {

        })
      })
      .disposed(by: disposeBag)

    viewModel.section1
      .asDriver()
      .drive(onNext: { [unowned self] items in
        self._dataController.update(in: self.section1, items: items, updateMode: .partial(animated: true), completion: {

        })
      })
      .disposed(by: disposeBag)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

    return CGSize(width: collectionView.bounds.width, height: 50)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: collectionView.bounds.width / 6, height: 50)
  }
}
