//
//  ActivityIndicatorTests.swift
//  RxSwiftUtilities
//
//  Created by Jesse Farless on 11/21/16.
//  Copyright © 2016 solidcell. All rights reserved.
//

import XCTest
import RxSwiftUtilities
import RxSwift

class ActivityIndicatorTests: XCTestCase {

    func testInitiallyEmitsFalse() {
        let activityIndicator = ActivityIndicator()
        var initialValue = true
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { initialValue = $0 })
        XCTAssertFalse(initialValue)
    }

    func testEmitsTrueWhenTracking() {
        let activityIndicator = ActivityIndicator()
        var value = false
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let _ = Observable.just(1)
            .concat(Observable.never())
            .trackActivity(activityIndicator)
            .subscribe()
        XCTAssertTrue(value)
    }
    
}
