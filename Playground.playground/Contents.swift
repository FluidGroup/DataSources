//: Playground - noun: a place where people can play

import Diff

do {
  let o = [1,2,3]
  let n = [1,4,3,5,6]

  let r = Diff.diffing(oldArray: o, newArray: n, isEqual: { l, r in l == r })
  r
}

do {

  var o = [1,2,3] // => [2,3,4]
  var c = ChangesCollection(source: o)
  c.append(4)
  c.remove(at: 1)

  let r = c.result
}

