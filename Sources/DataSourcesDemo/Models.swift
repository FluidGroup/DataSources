//
//  Models.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/9/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import Foundation

import RxSwift
import EasyPeasy
import DataSources

struct ModelA: Diffable {

  var diffIdentifier: AnyHashable {
    return AnyHashable(identity)
  }

  let identity: String
  let title: String
}

struct ModelB: Diffable {

  var diffIdentifier: AnyHashable {
    return AnyHashable(identity)
  }

  let identity: String
  let title: String
}


final class ViewModel {

  let section0 = Variable<[ModelA]>([])
  let section1 = Variable<[ModelB]>([])

  private let disposeBag = DisposeBag()

  init() {

  }

  func add() {
    for _ in 0..<20 {
      self.section0.value.insert(ModelA(identity: UUID().uuidString, title: String.randomEmoji()), at: 0)
    }
    for _ in 0..<20 {
      self.section1.value.insert(ModelB(identity: UUID().uuidString, title: arc4random_uniform(20).description), at: 0)
    }
  }

  func addRemove() {
    section0.value.removeFirst()
    DispatchQueue.global().async {
      self.section0.value.append(ModelA(identity: UUID().uuidString, title: String.randomEmoji()))
    }

    section1.value.removeLast()
    DispatchQueue.global().async {
      self.section1.value.append(ModelB(identity: UUID().uuidString, title: arc4random_uniform(30).description))
    }
  }

  func remove() {
    if section0.value.isEmpty == false {
      section0.value.removeFirst()
    }
    if section1.value.isEmpty == false {
      section1.value.removeLast()
    }
  }

  func shuffle() {
    section0.value = section0.value.shuffled()
    section1.value = section1.value.shuffled()
  }
}

final class Header: UICollectionReusableView {

  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(label)

    label <- Edges(8)

    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 20)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class Cell: UICollectionViewCell {

  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(label)
    label <- Edges(16)

    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
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
