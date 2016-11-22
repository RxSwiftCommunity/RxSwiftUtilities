//
//  ActivityIndicatorTests.swift
//  RxSwiftUtilities
//
//  Created by Jesse Farless on 11/21/16.
//  Copyright © 2016 RxSwiftCommunity. All rights reserved.
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

    func testEmitsTrueWhenTrackingASingleObservable() {
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

    func testEmitsFalseWhenFinishedTrackingASingleObservable() {
        let activityIndicator = ActivityIndicator()
        var value = true
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let subject = BehaviorSubject(value: 1)
        let _ = subject.asObservable()
            .trackActivity(activityIndicator)
            .subscribe()
        subject.onCompleted()
        XCTAssertFalse(value)
    }

    func testEmitsTrueWhenTrackingMultipleObservables() {
        let activityIndicator = ActivityIndicator()
        var value = false
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let _ = Observable.just(1)
            .concat(Observable.never())
            .trackActivity(activityIndicator)
            .subscribe()
        let _ = Observable.just(2)
            .concat(Observable.never())
            .trackActivity(activityIndicator)
            .subscribe()
        XCTAssertTrue(value)
    }

    func testDoesNotEmitFalseWhenFinishedTrackingOnlyOneOfMultipleObservables() {
        let activityIndicator = ActivityIndicator()
        var value = false
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let subject1 = BehaviorSubject(value: 1)
        let _ = subject1.asObservable()
            .trackActivity(activityIndicator)
            .subscribe()
        let subject2 = BehaviorSubject(value: 1)
        let _ = subject2.asObservable()
            .trackActivity(activityIndicator)
            .subscribe()
        subject1.onCompleted()
        XCTAssertTrue(value)
    }

    func testEmitsFalseWhenFinishedTrackingMultipleObservables() {
        let activityIndicator = ActivityIndicator()
        var value = true
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let subject1 = BehaviorSubject(value: 1)
        let _ = subject1.asObservable()
            .trackActivity(activityIndicator)
            .subscribe()
        let subject2 = BehaviorSubject(value: 1)
        let _ = subject2.asObservable()
            .trackActivity(activityIndicator)
            .subscribe()
        subject1.onCompleted()
        subject2.onCompleted()
        XCTAssertFalse(value)
    }

    func testEmitsFalseWhenTrackingObservablesAreDisposed() {
        let activityIndicator = ActivityIndicator()
        var value = true
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let disposable = Observable.just(1)
            .concat(Observable.never())
            .trackActivity(activityIndicator)
            .subscribe()
        disposable.dispose()
        XCTAssertFalse(value)
    }
    
}
