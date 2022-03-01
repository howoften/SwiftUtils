//
//  weakArray.swift
//  ShakeU
//
//  Created by liujiang on 2021/5/13.
//  Copyright © 2021 com.xiaoxian.ShakeU. All rights reserved.
//

import Foundation
import UIKit
// define WeakBox, so we can turn any strong reference into a weak one
/**
 eg.
 let instance = UIView()
 let weakReference = WeakBox(instance)

 use on array collection
 let strongArray = [UIView(), UIView()]
 let weakArray = strongArray.map { WeakBox($0) }
 */
private final class WeakBox<A: AnyObject> {
    weak var unbox: A?
    init(_ value: A) {
        unbox = value
    }
}

// a lightweight wrapper around an array
// use WeakArray like any other collection,
// e.g. calling filter on it, or using its first and last properties
class WeakArray<Element: AnyObject>: Collection, CustomStringConvertible {
    var startIndex: Int { self.trimReleasedElement(); return items.startIndex }
    var endIndex: Int { self.trimReleasedElement(); return items.endIndex }
    private var items: [WeakBox<Element>] = []

    init(_ elements: [Element]? = nil) {
        if let ele = elements {
            items = ele.map { WeakBox($0) }
        }
    }

    subscript(_ index: Int) -> Element? {
        get {
            self.trimReleasedElement()
            return items[index].unbox
        }
        set {
            self.trimReleasedElement()
            if let element = newValue {
                items[index] = WeakBox(element)
                return
            }
            self.remove(at: index)
        }
    }
    
    func index(after idx: Int) -> Int {
        self.trimReleasedElement();
        return items.index(after: idx)
    }
    var isEmpty: Bool { self.trimReleasedElement(); return items.isEmpty }
    var count: Int { self.trimReleasedElement(); return items.count }
    var first: Element? { self.trimReleasedElement(); return items.first?.unbox }
    var last: Element? { self.trimReleasedElement(); return items.last?.unbox }
    
    var description: String {
        var formateString = "["
        self.items.forEach {
            if let ele = $0.unbox {
                formateString = "\(formateString)\n\t\(ele),"
            }else {
                formateString = "\(formateString)\n\t\($0),"
            }
        }
        if formateString.count > 1 {
            formateString += "\n]"
        }else {
            formateString += "\t]"
        }
        return formateString
    }
}

extension WeakArray where Element: AnyObject {
    func append(_ newElement: Element) {
        return items.append(WeakBox(newElement))
    }

    @discardableResult
    func remove(at index: Int) -> Element {
        self.trimReleasedElement();
        return items.remove(at: index).unbox!
    }

    func removeAll(keepingCapacity keepCapacity: Bool = false) {
        return items.removeAll(keepingCapacity: keepCapacity)
    }

    func insert(_ newElement: Element, at i: Int) {
        self.trimReleasedElement();
        return items.insert(WeakBox(newElement), at: i)
    }

    func remove(_ oldElement: Element) {
        self.items = items.filter({ $0.unbox != nil && $0.unbox !== oldElement })
    }

    func first(where predicate: (Element?) throws -> Bool) rethrows -> Element? {
        self.trimReleasedElement();
        return try items.first(where: {
            return try predicate($0.unbox)
        })?.unbox
    }
    func contains(_ element: Element) -> Bool {
        return self.items.firstIndex(where: { $0.unbox != nil }) != nil
    }
    
    private func trimReleasedElement() {
        let releasedElement: [WeakBox<Element>] = items.filter({ $0.unbox == nil })
        guard !releasedElement.isEmpty else {
            return
        }
        
        releasedElement.forEach { element in
            if let index = items.firstIndex(where: { $0 === element }) {
                items.remove(at: index)
            }
        }
    }
}
