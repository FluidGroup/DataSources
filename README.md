# DataSources

💾 🗄 Data-driven CollectionView Framework. (Can adapt ASCollectionNode)

## Thanks

**Diff-algorithm**
- IGListKit-IGListDiff
  - https://github.com/Instagram/IGListKit
  - https://github.com/lxcid/ListDiff

## Usage

### Conform protocol `Diffable`

```swift
public protocol Diffable {
  associatedtype Identifier : Hashable
  var diffIdentifier: Identifier { get }
}
```

```swift
struct Model : Diffable {

  var diffIdentifier: String {
    return id
  }
  
  let id: String
}
```

### Single-Section (UICollectionView)

1. Define SectionDataSource in ViewController

```swift

let collectionView: UICollectionView
var models: [Model]

let sectionDataSource = SectionDataSource<Model, CollectionViewAdapter>(
  adapter: CollectionViewAdapter(collectionView: self.collectionView),
  displayingSection: 0,
  isEqual: { $0.id == $1.id }
)
```

2. Bind Models to SectionDataSource

```swift

var models: [Model] = […] {
  didSet {
    sectionDataSource.update(items: items, updateMode: .partial(animated: true), completion: {
      // Completed update
    })
  }
}

```

3. Implement UICollectionViewDataSource

```swift
func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return sectionDataSource.numberOfItems()
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
    let m = sectionDataSource.item(for: indexPath)
    cell.label.text = m.title
    return cell
  }
```

### Multiple-Section (UICollectionView)

# Author

muukii, m@muukii.me

# License

**DataSources** is available under the MIT license. See the LICENSE file for more info.
