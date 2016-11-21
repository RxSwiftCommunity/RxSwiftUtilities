//
//  RxSwiftUtilitiesTestClass.swift
//  RxSwiftUtilities
//
//  Created by Jesse Farless on 11/21/16.
//  Copyright © 2016 solidcell. All rights reserved.
//

import XCTest
import RxSwiftUtilities

class RxSwiftUtilitiesTestClassTests: XCTestCase {
    
    func testMessage() {
        let testClass = RxSwiftUtilitiesTestClass()
        XCTAssertEqual(testClass.message(), "Success!")
    }
    
}
