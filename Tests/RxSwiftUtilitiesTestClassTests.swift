//
//  RxSwiftUtilitiesTestClass.swift
//  RxSwiftUtilities
//
//  Created by Jesse Farless on 11/21/16.
//  Copyright © 2016 solidcell. All rights reserved.
//

import XCTest
import RxSwiftUtilities
import RxSwift

class RxSwiftUtilitiesTestClassTests: XCTestCase {
    
    func testMessage() {
        let testClass = RxSwiftUtilitiesTestClass()
        XCTAssertEqual(testClass.message(), "Success!")
    }
    
    func testObservable() {
        let testClass = RxSwiftUtilitiesTestClass()
        var asdf = 2
        let _ = testClass.someObservable()
            .subscribe(onNext: { asdf = $0 })
        XCTAssertEqual(asdf, 1)
    }
    
}
