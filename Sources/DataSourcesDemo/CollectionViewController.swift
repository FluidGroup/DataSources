//
//  CollectionViewController.swift
//  ListAdapterDemo
//
//  Created by muukii on 8/8/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import UIKit

import DataSources
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
    adapter: .init(collectionView: self.collectionView),
    displayingSection: 0,
    isEqual: { a, b in a.identity == b.identity }
  )

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

    viewModel.displayModels
      .asDriver()
      .drive(onNext: { [weak self] items in
        print("Begin update")
        self?.dataSource.update(items: items, updateMode: .partial(animated: true), completion: {
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
    cell.label.text = m.title
    cell.label.textAlignment = .center
    cell.label.font = UIFont.systemFont(ofSize: 20)
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

    return CGSize(width: collectionView.bounds.width / 6, height: 50)
  }
}

extension CollectionViewController {

  struct Model: Diffable {

    var diffIdentifier: AnyHashable {
      return AnyHashable(identity)
    }

    let identity: String
    let title: String
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
      for _ in 0..<30 {
        self.models.value.insert(Model(identity: UUID().uuidString, title: String.randomEmoji()), at: 0)
      }
    }

    func addRemove() {
      models.value.removeFirst()
      DispatchQueue.global().async {
        self.models.value.append(Model(identity: UUID().uuidString, title: String.randomEmoji()))
      }
    }

    func remove() {
      guard models.value.isEmpty == false else { return }
      models.value.removeFirst()
    }

    func shuffle() {
      models.value = models.value.shuffled()
    }
  }
}

extension Array {
  func shuffled() -> Array<Element> {
    var array = self

    for i in 0..<array.count {
      let ub = UInt32(array.count - i)
      let d = Int(arc4random_uniform(ub))

      let tmp = array[i]
      array[i] = array[i+d]
      array[i+d] = tmp
    }

    return array
  }
}

extension String{
  static func randomEmoji() -> String{
    let range = 0x1F601...0x1F64F
    let ascii = range.lowerBound + Int(arc4random_uniform(UInt32(range.count)))

    var view = UnicodeScalarView()
    view.append(UnicodeScalar(ascii)!)

    let emoji = String(view)

    return emoji
  }
}
