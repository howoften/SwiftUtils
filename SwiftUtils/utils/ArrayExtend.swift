//
//  arrayExtend.swift
//  SwiftUtils
//
//  Created by liujiang on 2022/3/1.
//

fileprivate var stateRecoder = [AnyHashable:Any]()
extension Array {
    mutating func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) {
        var arrayCopy = self.map({filter($0)})
        var l = arrayCopy.count
        for i in 0..<arrayCopy.count {
            for j in i+1..<arrayCopy.count {
                var n = 0
                let cur_l = l
                while arrayCopy[j] == arrayCopy[i] && n < (cur_l - j) {
                    for k in j+1..<l {
                        arrayCopy[k-1] = arrayCopy[k]
                        self[k-1] = self[k]
                    }
                    l -= 1
                    n += 1
                }
                
                if j + 1 >= l { break }
            }
            if i + 1 >= l { break }
        }
        self.removeSubrange(l..<self.count)
    }
    //[1, 2, 3]
    mutating func insert(_ element: Element, at index: Int, elementIncaseBeyondBounds: @autoclosure () -> Element) {
        var emptyIndex = stateRecoder[String(format: "%p", self)] as? [Int] ?? []
        stateRecoder[String(format: "%p", self)] = nil
        if index < self.count {
            if emptyIndex.contains(index) {
                self[index] = element
                if let index = emptyIndex.firstIndex(of: index) {
                    remove(at: index)
                }
            } else {
                self.insert(element, at: index)
                for i in index..<self.count {
                    if emptyIndex.contains(index) {
                        if let index_ = emptyIndex.firstIndex(of: i) {
                            emptyIndex.remove(at: index_)
                        }
                        break
                    }
                }
            }
        } else {
            for i in self.count..<index {
                emptyIndex.append(i)
                self.append(elementIncaseBeyondBounds())
            }
            self.append(element)
        }
        stateRecoder[String(format: "%p", self)] = emptyIndex
    }
    
    mutating func remove(_ elementForRemove: (Element) -> Bool) {
        let copy = self
        copy.forEach { ele in
            while let index = self.firstIndex(where: elementForRemove) {
                self.remove(at: index)
            }
        }
    }
    mutating func insert(_ elementForInsert: () -> Element, at index: Int) {
        self.insert(elementForInsert(), at: index)
    }
    
    mutating func replace(_ elementForReplace: (Element) -> Bool, with another: Element) {
        let copy = self
        copy.enumerated().forEach { tuple in
            if elementForReplace(tuple.element) {
                self[tuple.offset] = another
            }
        }
        
    }
    func contains(_ whether: (Element) -> Bool) -> Bool{
        var contain = false
        self.forEach {
            contain = contain || whether($0)
        }
       return contain
    }
    func object(_ objectFilter: (Element) -> Bool) -> Element? {
        for item in self {
            if objectFilter(item) {
                return item
            }
        }
       return nil
    }
    func objects(_ objectFilter: (Element) -> Bool) -> [Element]? {
        var result = [Element]()
        for item in self {
            if objectFilter(item) {
                result.append(item)
            }
        }
        return result.isEmpty ? nil : result
    }
    func index(_ objectIndexFilter: (Element) -> Bool) -> Int? {
        for (i, item) in self.enumerated() {
            if objectIndexFilter(item) {
                return i
            }
        }
       return nil
    }
    func indexs(_ objectIndexFilter: (Element) -> Bool) -> [Int]? {
        var result = [Int]()
        for (i, item) in self.enumerated() {
            if objectIndexFilter(item) {
                result.append(i)
            }
        }
        return result.isEmpty ? nil : result
    }
    /// (多维数组按照一维数组进行遍历).
    func enumerateNested(_ handler: (_ obj: Any, _ stop: inout Bool) -> Void) -> Void {
        var stop = false
        for i in self {
            if let arrEle = i as? [Any] {
                arrEle.enumerateNested(handler)
            } else {
                handler(i, &stop)
            }
            if stop { break }
        }
    }
    
    func reduceNested<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Any) throws -> Result) rethrows -> Result {
        var newResult = initialResult
        self.enumerateNested { item, stop in
            do {
                try newResult = nextPartialResult(newResult, item)
            }catch let e {
                print(e)
            }
        }
        return newResult
    }
   
}
