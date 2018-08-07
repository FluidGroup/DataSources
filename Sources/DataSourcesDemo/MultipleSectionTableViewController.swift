//
//  MultipleSectionTableViewController.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/10/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import DataSources
import EasyPeasy
import RxSwift
import RxCocoa

final class MultipleSectionTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

  private lazy var tableView: UITableView = UITableView(frame: .zero, style: .plain)

  private lazy var _dataSource: DataController<TableViewAdapter> = .init(adapter: .init(tableView: self.tableView))

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

    tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")

    view.addSubview(tableView)
    tableView <- Edges()

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

    tableView.delegate = self
    tableView.dataSource = self

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

  func numberOfSections(in tableView: UITableView) -> Int {
    return _dataSource.numberOfSections()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return _dataSource.numberOfItems(in: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    return _dataSource.item(
      at: indexPath,
      handlers: [
        .init(section: section0) { tableView, indexPath, m in
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
          cell.label.text = m.title
          return cell
        },
        .init(section: section1) { tableView, indexPath, m in
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
          cell.label.text = m.title
          return cell
        },
        ])
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 50
  }
}

