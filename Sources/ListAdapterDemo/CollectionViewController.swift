//
//  CollectionViewController.swift
//  ListAdapterDemo
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import ListAdapter
import EasyPeasy
import RxSwift
import RxCocoa

final class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

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

  private lazy var dataSource = SectionDataSource<Model, CollectionViewAdapter>(
    list: .init(collectionView: self.collectionView),
    displayingSection: 0,
    isEqual: { a, b in a.identity == b.identity }
  )

  private let add = UIBarButtonItem(title: "Add", style: .plain, target: nil, action: nil)
  private let remove = UIBarButtonItem(title: "Remove", style: .plain, target: nil, action: nil)
  private let addRemove = UIBarButtonItem(title: "AddRemove", style: .plain, target: nil, action: nil)
  private let viewModel = ViewModel()
  private let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(collectionView)
    collectionView <- Edges()

    navigationItem.rightBarButtonItems = [add, remove, addRemove]

    add.rx.tap
      .bind(onNext: viewModel.add)
      .disposed(by: disposeBag)

    remove.rx.tap
      .bind(onNext: viewModel.remove)
      .disposed(by: disposeBag)

    addRemove.rx.tap
      .bind(onNext: viewModel.addRemove)
      .disposed(by: disposeBag)

    collectionView.delegate = self
    collectionView.dataSource = self

    viewModel.displayModels
      .asDriver()
      .drive(onNext: { [weak self] items in
        print("Begin update")
        self?.dataSource.update(items: items, updatePartially: true, completion: {
          print("Complete")
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
    let m = dataSource.item(for: indexPath)
    cell.label.text = m.identity
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: collectionView.bounds.width, height: 50)
  }
}

extension CollectionViewController {

  struct Model: Diffable {

    var diffIdentifier: AnyHashable {
      return AnyHashable(identity)
    }

    let identity: String
  }

  final class Cell: UICollectionViewCell {

    let label = UILabel()

    override init(frame: CGRect) {
      super.init(frame: frame)

      contentView.addSubview(label)
      label <- Edges(16)
    }

    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  final class ViewModel {

    let displayModels = Variable<[Model]>([])

    let models = Variable<[Model]>([])

    private let disposeBag = DisposeBag()

    init() {

      models.value = [
      ]

      models.asObservable()
        .bind(to: displayModels)
        .disposed(by: disposeBag)
    }

    func add() {
      for _ in 0..<3 {
        self.models.value.append(Model(identity: UUID().uuidString))
      }
    }

    func addRemove() {
      models.value.removeFirst()
      DispatchQueue.global().async {
        self.models.value.append(Model(identity: UUID().uuidString))
      }
    }

    func remove() {
      models.value.remove(at: 1)
    }
  }
}
