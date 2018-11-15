//
//  ErrorTrackerTests.swift
//  RxSwiftUtilities
//
//  Created by Rafael Ferreira on 11/15/18.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import RxCocoa
import RxSwift
import RxSwiftUtilities
import XCTest

class ErrorTrackerTests: XCTestCase {
    func testInitiallyEmitsNothing() {
        let errorTracker = ErrorTracker()
        var isInvoked = false
        let _ = errorTracker.asObservable()
            .subscribe(onNext: { _ in isInvoked = true })
        XCTAssertFalse(isInvoked)
    }

    func testEmitsErrorWhenTrackingASingleObservable() {
        let errorTracker = ErrorTracker()
        var value: Error? = nil

        let _ = errorTracker.asObservable()
            .subscribe(onNext: { error in value = error })

        let _ = Observable<Any>.error(RxError.noElements)
            .trackError(errorTracker)
            .subscribe()

        XCTAssertNotNil(value)
    }

    func testEmitsNothingWhenTrackingASingleObservable() {
        let errorTracker = ErrorTracker()
        var value: Error? = nil

        let _ = errorTracker.asObservable()
            .subscribe(onNext: { error in value = error })

        let _ = Observable.just(1)
            .trackError(errorTracker)
            .subscribe()

        XCTAssertNil(value)
    }
}
