//
//  WateringCppTests.swift
//  WateringCppTests
//
//  Created by kenta on 2017/03/28.
//  Copyright © 2017年 sidepelican. All rights reserved.
//

import XCTest

class WateringCppTests: XCTestCase {
    
    func testSimple() {
        
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
    }
    
    func testDetails() {
        
        if let f = CppFunction(line: "  int size() const;          // size") {
            XCTAssertEqual(f.nameAndArgs, "size()")
            XCTAssertEqual(f.returnType, "int")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .some("// size"))
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "   virtual vector<string> names() ;") {
            XCTAssertEqual(f.nameAndArgs, "names()")
            XCTAssertEqual(f.returnType, "vector<string>")
            XCTAssertEqual(f.hasVirtual, true)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "pair<int, float> find(const std::string& key) const;") {
            XCTAssertEqual(f.nameAndArgs, "find(const std::string& key)")
            XCTAssertEqual(f.returnType, "pair<int,float>")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "virtual map<int, list<int> > map(const string& key, int max) const; //  dangerous") {
            XCTAssertEqual(f.nameAndArgs, "map(const string& key, int max)")
            XCTAssertEqual(f.returnType, "map<int,list<int>>")
            XCTAssertEqual(f.hasVirtual, true)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .some("//  dangerous"))
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "map<int, map<int, int>> map(const map<int, int>& a);") {
            XCTAssertEqual(f.nameAndArgs, "map(const map<int, int>& a)")
            XCTAssertEqual(f.returnType, "map<int,map<int,int>>")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "virtual int hoge(AAA* aaa) override;") {
            XCTAssertEqual(f.nameAndArgs, "hoge(AAA* aaa)")
            XCTAssertEqual(f.returnType, "int")
            XCTAssertEqual(f.hasVirtual, true)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, true)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
    
        if let f = CppFunction(line: "virtual int hoge(AAA* aaa) const override;") {
            XCTAssertEqual(f.nameAndArgs, "hoge(AAA* aaa)")
            XCTAssertEqual(f.returnType, "int")
            XCTAssertEqual(f.hasVirtual, true)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, true)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "void getOptimized(vector<GridInfo>* gridResult, GridToEdgeBit* edgeResult) const; // comment") {
            XCTAssertEqual(f.nameAndArgs, "getOptimized(vector<GridInfo>* gridResult, GridToEdgeBit* edgeResult)")
            XCTAssertEqual(f.returnType, "void")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .some("// comment"))
        }else{
            XCTFail("could not parse")
        }
    }
    
    func testBrackets() {
        
        if let f = CppFunction(line: "float test(CONSTREF(AAA) aaa);") {
            XCTAssertEqual(f.nameAndArgs, "test(CONSTREF(AAA) aaa)")
            XCTAssertEqual(f.returnType, "float")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }

        if let f = CppFunction(line: "CONSTREF(vector<int>) test() const;    // some comments") {
            XCTAssertEqual(f.nameAndArgs, "test()")
            XCTAssertEqual(f.returnType, "CONSTREF(vector<int>)")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, true)
            XCTAssertEqual(f.comment, .some("// some comments"))
        }else{
            XCTFail("could not parse")
        }
    }
    
    func testDefaultValue() {

        if let f = CppFunction(line: "void do(bool a = true); // some") {
            XCTAssertEqual(f.nameAndArgs, "do(bool a)")
            XCTAssertEqual(f.returnType, "void")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .some("// some"))
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "void do(int aa = 22, string text = \"hello\"); // some") {
            XCTAssertEqual(f.nameAndArgs, "do(int aa, string text)")
            XCTAssertEqual(f.returnType, "void")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .some("// some"))
        }else{
            XCTFail("could not parse")
        }
        
        if let f = CppFunction(line: "virtual int eat(const vector<Food>& foods, float wait = 0.f) override;") {
            XCTAssertEqual(f.nameAndArgs, "eat(const vector<Food>& foods, float wait)")
            XCTAssertEqual(f.returnType, "int")
            XCTAssertEqual(f.hasVirtual, true)
            XCTAssertEqual(f.hasStatic, false)
            XCTAssertEqual(f.hasOverride, true)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
    }
    
    func testStatic() {

        if let f = CppFunction(line: "static int do();") {
            XCTAssertEqual(f.nameAndArgs, "do()")
            XCTAssertEqual(f.returnType, "int")
            XCTAssertEqual(f.hasVirtual, false)
            XCTAssertEqual(f.hasStatic, true)
            XCTAssertEqual(f.hasOverride, false)
            XCTAssertEqual(f.hasConst, false)
            XCTAssertEqual(f.comment, .none)
        }else{
            XCTFail("could not parse")
        }
    }
}
