//
//  CollectionViewController.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import RxSwift
import EasyPeasy
import DataSources

final class SingleSectionCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

  private lazy var dataSource: SectionDataController<ModelA, CollectionViewAdapter> = .init(
    adapter: .init(collectionView: self.collectionView),
    displayingSection: 0
  )

  private let add = UIBarButtonItem(title: "Add", style: .plain, target: nil, action: nil)
  private let remove = UIBarButtonItem(title: "Remove", style: .plain, target: nil, action: nil)
  private let addRemove = UIBarButtonItem(title: "AddRemove", style: .plain, target: nil, action: nil)
  private let shuffle = UIBarButtonItem(title: "Shuffle", style: .plain, target: nil, action: nil)

  private let disposeBag: DisposeBag = .init()  
  private let viewModel = ViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    collectionView <- Edges()

    navigationItem.rightBarButtonItems = [add, remove, addRemove, shuffle]

    add.primaryAction = .init(handler: { [unowned self] _ in
      viewModel.add()
    })

    remove.primaryAction = .init(handler: { [unowned self] _ in
      viewModel.remove()
    })

    addRemove.primaryAction = .init(handler: { [unowned self] _ in
      viewModel.addRemove()
    })

    shuffle.primaryAction = .init(handler: { [unowned self] _ in
      viewModel.shuffle()
    })

    collectionView.delegate = self
    collectionView.dataSource = self

    viewModel.section0
      .subscribe(onNext: { [weak self] items in 
        print("Begin update")
        self?.dataSource.update(items: items, updateMode: .partial(animated: true), completion: {
          print("Throttled Complete")
        })
      })
      .disposed(by: disposeBag)
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.numberOfItems()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
    let m = dataSource.item(at: indexPath)!
    cell.label.text = m.title
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: collectionView.bounds.width / 6, height: 50)
  }
}
