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
    func testInitiallyEmitsNothingForPublishRelay() {
        let errorTracker = PublishRelay<Error>()
        var isInvoked = false
        let _ = errorTracker.asObservable()
            .subscribe(onNext: { _ in isInvoked = true })
        XCTAssertFalse(isInvoked)
    }

    func testEmitsErrorWhenTrackingASingleObservableForPublishRelay() {
        let errorTracker = PublishRelay<Error>()
        var value: Error? = nil

        let _ = errorTracker.asObservable()
            .subscribe(onNext: { error in value = error })

        let _ = Observable<Any>.error(RxError.noElements)
            .forwardError(to: errorTracker)
            .subscribe()

        XCTAssertNotNil(value)
    }

    func testEmitsNothingWhenTrackingASingleObservableForPublishRelay() {
        let errorTracker = PublishRelay<Error>()
        var value: Error? = nil

        let _ = errorTracker.asObservable()
            .subscribe(onNext: { error in value = error })

        let _ = Observable.just(1)
            .forwardError(to: errorTracker)
            .subscribe()

        XCTAssertNil(value)
    }

    func testInitiallyEmitsNothingForPublishSubject() {
        let errorTracker = PublishSubject<Error>()
        var isInvoked = false
        let _ = errorTracker.asObservable()
            .subscribe(onNext: { _ in isInvoked = true })
        XCTAssertFalse(isInvoked)
    }

    func testEmitsErrorWhenTrackingASingleObservableForPublishSubject() {
        let errorTracker = PublishSubject<Error>()
        var value: Error? = nil

        let _ = errorTracker.asObservable()
            .subscribe(onNext: { error in value = error })

        let _ = Observable<Any>.error(RxError.noElements)
            .forwardError(to: errorTracker)
            .subscribe()

        XCTAssertNotNil(value)
    }

    func testEmitsNothingWhenTrackingASingleObservableForPublishSubject() {
        let errorTracker = PublishSubject<Error>()
        var value: Error? = nil

        let _ = errorTracker.asObservable()
            .subscribe(onNext: { error in value = error })

        let _ = Observable.just(1)
            .forwardError(to: errorTracker)
            .subscribe()

        XCTAssertNil(value)
    }
}
