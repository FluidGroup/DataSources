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
import AsyncDisplayKit

protocol Model {
  var title: String { get }
}

struct ModelA : Model, Differentiable, Equatable {

  var differenceIdentifier: String {
    return identity
  }

  let identity: String
  let title: String

  func isContentEqual(to source: ModelA) -> Bool {
    return self == source
  }
}

struct ModelB : Model, Differentiable, Equatable {

  var differenceIdentifier: String {
    return identity
  }

  let identity: String
  let title: String

  func isContentEqual(to source: ModelB) -> Bool {
    return self == source
  }
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

    section1.value.removeFirst()
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

final class Header : UICollectionReusableView {

  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(label)

    label.easy.layout(Edges(8))

    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 20)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class Cell : UICollectionViewCell {

  let label = UILabel()
  private let paddingView = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(paddingView)
    contentView.addSubview(label)
    label.easy.layout(Center())
    paddingView.easy.layout(Edges(2))

    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20)

    paddingView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    paddingView.layer.cornerRadius = 4
    paddingView.layer.shouldRasterize = true
    paddingView.layer.rasterizationScale = UIScreen.main.scale
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class CellNode : ASCellNode {

  private let textNode = ASTextNode()
  private let paddingNode = ASDisplayNode()

  init(model: Model) {
    super.init()

    textNode.attributedText = NSAttributedString(
      string: model.title,
      attributes: [
        .font : UIFont.systemFont(ofSize: 20),
      ]
    )
    paddingNode.backgroundColor = UIColor(white: 0.95, alpha: 1)

    automaticallyManagesSubnodes = true
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    return ASInsetLayoutSpec(
      insets: .init(top: 2, left: 2, bottom: 2, right: 2),
      child: ASWrapperLayoutSpec(layoutElements: [
        paddingNode,
        ASCenterLayoutSpec(
          horizontalPosition: .center,
          verticalPosition: .center,
          sizingOption: .minimumSize,
          child: textNode)
        ]
      )
    )

  }
}

final class TableViewCell : UITableViewCell {

  let label = UILabel()
  private let paddingView = UIView()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    contentView.addSubview(paddingView)
    contentView.addSubview(label)
    label.easy.layout(Center())
    paddingView.easy.layout(Edges(2))

    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 20)

    paddingView.backgroundColor = UIColor(white: 0.95, alpha: 1)
    paddingView.layer.cornerRadius = 4
    paddingView.layer.shouldRasterize = true
    paddingView.layer.rasterizationScale = UIScreen.main.scale
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
