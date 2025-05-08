//
//  File.swift
//
//
//  Created by wp on 2023/6/29.
//

import CodableWrapper
import Foundation

@Codable
class ClassModel0: Codable {
    var val: String = "0"
    var val1 = "abc"
    var val11 = 123
    var val111 = 123.4
    var val1111 = true
    var val2: Int?

    lazy var lazyVal: Double = val111 * 2

//    var val3 = [String: String].init()
//    var val4 = [123] + [4]
}

@Codable
class ClassModel1 {
    var val: String = "1"
}

@Codable
public class ClassModel11 {
    var val: String = "1"
}

@Codable
open class ClassModel111 {
    open var val: String = "1"
}

@CodableSubclass
class ClassSubmodel0: ClassModel0 {
    @CodingKey("abc")
    var x: String = "0_0"
    var y: String

    init(x: String, y: String) {
        self.x = x
        self.y = y
        super.init()
    }
}

@CodableSubclass
class ClassSubmodel1: ClassModel1 {
    var subVal: String = "1_1"
}

struct StructWraningX {
    @CodingKey("abc") var subVal: String = "1_1"
}

public extension ClassModel11 {
    @Codable
    class A {
        public var val: String = "1"
    }
}

// @CodableSubclass
// struct StructWraning0 {}
//
// @CodingKey("a")
// struct StructWraning1 {}
//
// @CodingNestedKey("a")
// struct StructWraning2 {}
//
// @CodingTransformer(StringPrefixTransform("HELLO -> "))
// struct StructWraning3 {}
