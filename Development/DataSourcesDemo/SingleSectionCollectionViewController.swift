import DataSources
import RxSwift
import SwiftUIHosting
import UIKit

enum NonIsolated {
  
  func run(collectionView: UICollectionView) {
    
    let dataSource: SectionDataController<ModelA, CollectionViewAdapter> = .init(
      adapter: .init(collectionView: collectionView),
      displayingSection: 0
    )
    
  }
  
}

final class SingleSectionCollectionViewController: UIViewController, UICollectionViewDataSource,
  UICollectionViewDelegateFlowLayout
{

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
  private let addRemove = UIBarButtonItem(
    title: "AddRemove", style: .plain, target: nil, action: nil)
  private let shuffle = UIBarButtonItem(title: "Shuffle", style: .plain, target: nil, action: nil)

  private let disposeBag: DisposeBag = .init()
  private let viewModel = ViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    let hostingView = SwiftUIHostingView(configuration: .init(disableSafeArea: false)) {
      HStack {
        Button("Add") { [unowned self] in
          viewModel.add()
        }
        Button("Remove") { [unowned self] in
          viewModel.remove()
        }
        Button("AddRemove") { [unowned self] in
          viewModel.addRemove()
        }
        Button("Shuffle") { [unowned self] in
          viewModel.shuffle()
        }
      }
      ViewHost(instantiated: collectionView)
    }
    
    view.addSubview(hostingView)
    hostingView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      hostingView.topAnchor.constraint(equalTo: view.topAnchor),
      hostingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      hostingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      hostingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
    
    collectionView.delegate = self
    collectionView.dataSource = self

    viewModel.section0
      .subscribe(onNext: { [weak self] items in
        print("Begin update")
        self?.dataSource.update(
          items: items, updateMode: .partial(animated: true),
          completion: {
            print("Throttled Complete")
          })
      })
      .disposed(by: disposeBag)
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int
  {
    return dataSource.numberOfItems()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell
  {

    let cell =
      collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
    let m = dataSource.item(at: indexPath)!
    cell.label.text = m.title
    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {

    return CGSize(width: collectionView.bounds.width / 6, height: 50)
  }
}

import SwiftUI

private struct ViewHost<ContentView: UIView>: UIViewRepresentable {
  
  private let contentView: ContentView
  private let _update: @MainActor (_ uiView: ContentView, _ context: Context) -> Void
  
  public init(
    instantiated: ContentView,
    update: @escaping @MainActor (_ uiView: ContentView, _ context: Context) -> Void = { _, _ in }
  ) {
    self.contentView = instantiated
    self._update = update
  }
  
  public func makeUIView(context: Context) -> ContentView {
    return contentView
  }
  
  public func updateUIView(_ uiView: ContentView, context: Context) {
    _update(uiView, context)
  }
  
}
