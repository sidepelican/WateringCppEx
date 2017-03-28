//
//  WateringCppTests.swift
//  WateringCppTests
//
//  Created by kenta on 2017/03/28.
//  Copyright © 2017年 sidepelican. All rights reserved.
//

import XCTest

class WateringCppTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        XCTAssert(true, "ok")
        
        [
            "int size() const;                   // サイズ",
            "bool empty() const;                 // 空かどうか",
            "bool contains(Touch* t) const;      // 指定タッチが含まれてるか",
            "void insert(Touch* t);              // タッチの追加",
            "void erase(Touch* t);               // タッチの削除",
            "Vec2 getTouchMoveVelocity() const;  // 全体でのタップ速度を取得",
            "void touchMoved(Touch* t);          // タップ移動時のイベントをハンドル",
            ]
            .forEach { line in
                XCTAssertNotNil(CppFunction(line: line), line)
        }
        
        if let f = CppFunction(line: "  int size() const;          // size") {
            XCTAssertEqual(f.nameAndArgs, "size()")
            XCTAssertEqual(f.returnType, "int")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .some("// size"))
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "   virtual vector<string> names() ;") {
            XCTAssertEqual(f.nameAndArgs, "names()")
            XCTAssertEqual(f.returnType, "vector<string>")
            XCTAssertEqual(f.hasVirtual, true)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "pair<int, float> find(const std::string& key) const;") {
            XCTAssertEqual(f.nameAndArgs, "find(const std::string& key)")
            XCTAssertEqual(f.returnType, "pair<int,float>")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "virtual map<int, list<int> > map(const string& key, int max) const; //  dangerous") {
            XCTAssertEqual(f.nameAndArgs, "map(const string& key, int max)")
            XCTAssertEqual(f.returnType, "map<int,list<int>>")
            XCTAssertEqual(f.hasVirtual, true)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .some("//  dangerous"))
        }else{
            XCTFail("could not parse")
        }

        // TODO: failed
//        if let f = CppFunction(line: "map<int, map<int, int>> map(const map<int, int>& a);") {
//            XCTAssertEqual(f.nameAndArgs, "map(const map<int, int>& a)")
//            XCTAssertEqual(f.returnType, "map<int, map<int, int>>")
//            XCTAssertEqual(f.hasVirtual, false)
//            XCTAssertEqual(f.hasConst, false)
//            XCTAssertEqual(f.comment, .none)
//        }else{
//            XCTFail("could not parse")
//        }
    }
}
