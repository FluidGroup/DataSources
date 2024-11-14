//
//  Models.swift
//  DataSourcesDemo
//
//  Created by muukii on 8/9/17.
//  Copyright © 2017 muukii. All rights reserved.
//

import AsyncDisplayKit
import DataSources
import Foundation
import RxRelay
import RxSwift

protocol Model {
  var title: String { get }
}

struct ModelA: Model, Differentiable, Equatable {

  var differenceIdentifier: String {
    return identity
  }

  let identity: String
  let title: String

  func isContentEqual(to source: ModelA) -> Bool {
    return self == source
  }
}

struct ModelB: Model, Differentiable, Equatable {

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

  let section0 = BehaviorRelay<[ModelA]>(value: [])
  let section1 = BehaviorRelay<[ModelB]>(value: [])

  private let disposeBag = DisposeBag()

  init() {

  }

  func add() {
    for _ in 0..<20 {
      self.section0.modify {
        $0.insert(ModelA(identity: UUID().uuidString, title: String.randomEmoji()), at: 0)
      }
    }
    for _ in 0..<20 {
      self.section1.modify {
        $0.insert(
          ModelB(identity: UUID().uuidString, title: arc4random_uniform(20).description), at: 0)
      }
    }
  }

  func addRemove() {
    section0.modify {
      $0.removeFirst()
    }
    DispatchQueue.global().async {
      self.section0.modify {
        $0.append(ModelA(identity: UUID().uuidString, title: String.randomEmoji()))
      }
    }

    section1.modify {
      $0.removeFirst()
    }
    DispatchQueue.global().async {
      self.section1.modify {
        $0.append(ModelB(identity: UUID().uuidString, title: arc4random_uniform(30).description))
      }
    }
  }

  func remove() {
    if section0.value.isEmpty == false {
      section0.modify {
        $0.removeFirst()
      }
    }
    if section1.value.isEmpty == false {
      section1.modify {
        $0.removeFirst()
      }
    }
  }

  func shuffle() {
    section0.modify {
      $0 = $0.shuffled()
    }

    section1.modify {
      $0 = $0.shuffled()
    }
  }
}

final class Header: UICollectionReusableView {

  let label = UILabel()

  override init(frame: CGRect) {
    super.init(frame: frame)

    addSubview(label)
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: topAnchor),

      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 20)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

final class Cell: UICollectionViewCell {

  let label = UILabel()
  private let paddingView = UIView()

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.addSubview(paddingView)
    contentView.addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: contentView.topAnchor),      
      label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
    
    paddingView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      paddingView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
      paddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
      paddingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2),
      paddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
    ])
      
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

final class CellNode: ASCellNode {

  private let textNode = ASTextNode()
  private let paddingNode = ASDisplayNode()

  init(model: Model) {
    super.init()

    textNode.attributedText = NSAttributedString(
      string: model.title,
      attributes: [
        .font: UIFont.systemFont(ofSize: 20)
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
          child: textNode),
      ]
      )
    )

  }
}

extension Array {
  func shuffled() -> [Element] {
    var array = self

    for i in 0..<array.count {
      let ub = UInt32(array.count - i)
      let d = Int(arc4random_uniform(ub))

      let tmp = array[i]
      array[i] = array[i + d]
      array[i + d] = tmp
    }

    return array
  }
}

extension String {
  static func randomEmoji() -> String {
    let range = 0x1F601...0x1F64F
    let ascii = range.lowerBound + Int(arc4random_uniform(UInt32(range.count)))

    var view = UnicodeScalarView()
    view.append(UnicodeScalar(ascii)!)

    let emoji = String(view)

    return emoji
  }
}

extension BehaviorRelay {

  // no-thread-safe
  func modify(_ modifier: (inout Element) -> Void) {
    var value = self.value
    modifier(&value)
    self.accept(value)
  }

}
