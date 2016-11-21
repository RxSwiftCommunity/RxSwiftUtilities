//
//  ActivityIndicatorTests.swift
//  RxSwiftUtilities
//
//  Created by Jesse Farless on 11/21/16.
//  Copyright © 2016 solidcell. All rights reserved.
//

import XCTest
import RxSwiftUtilities

class ActivityIndicatorTests: XCTestCase {
    
    func testInitiallyEmitsFalse() {
        let activityIndicator = ActivityIndicator()
        var initialValue = true
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { initialValue = $0 })
        XCTAssertFalse(initialValue)
    }
    
}
