//
//  ActivityIndicatorDriverTests.swift
//  RxSwiftUtilitiesTests iOS
//
//  Created by Shawn Simon on 2019-06-24.
//  Copyright © 2019 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import RxSwiftUtilities

extension ActivityIndicatorTests {
    
    func testEmitsTrueWhenTrackingASingleObservable_asDriver() {
        let activityIndicator = ActivityIndicator()
        var value = false
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let _ = Observable.just(1)
            .concat(Observable.never())
            .asDriver(onErrorJustReturn: 1)
            .trackActivity(activityIndicator)
            .drive()
        XCTAssertTrue(value)
    }
    
    func testEmitsFalseWhenFinishedTrackingASingleObservable_asDriver() {
        let activityIndicator = ActivityIndicator()
        var value = true
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let subject = BehaviorSubject(value: 1)
        let _ = subject.asDriver(onErrorJustReturn: 1)
            .trackActivity(activityIndicator)
            .subscribe()
        subject.onCompleted()
        XCTAssertFalse(value)
    }
    
    func testEmitsTrueWhenTrackingMultipleObservables_asDriver() {
        let activityIndicator = ActivityIndicator()
        var value = false
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let _ = Observable.just(1)
            .concat(Observable.never())
            .asDriver(onErrorJustReturn: 1)
            .trackActivity(activityIndicator)
            .drive()
        let _ = Observable.just(2)
            .concat(Observable.never())
            .asDriver(onErrorJustReturn: 2)
            .trackActivity(activityIndicator)
            .drive()
        XCTAssertTrue(value)
    }
    
    func testDoesNotEmitFalseWhenFinishedTrackingOnlyOneOfMultipleObservables_asDriver() {
        let activityIndicator = ActivityIndicator()
        var value = false
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let subject1 = BehaviorSubject(value: 1)
        let _ = subject1.asDriver(onErrorJustReturn: 1)
            .trackActivity(activityIndicator)
            .drive()
        let subject2 = BehaviorSubject(value: 1)
        let _ = subject2.asDriver(onErrorJustReturn: 1)
            .trackActivity(activityIndicator)
            .drive()
        subject1.onCompleted()
        XCTAssertTrue(value)
    }
    
    func testEmitsFalseWhenFinishedTrackingMultipleObservables_asDriver() {
        let activityIndicator = ActivityIndicator()
        var value = true
        let _ = activityIndicator.asObservable()
            .subscribe(onNext: { value = $0 })
        let subject1 = BehaviorSubject(value: 1)
        let _ = subject1.asDriver(onErrorJustReturn: 1)
            .trackActivity(activityIndicator)
            .drive()
        let subject2 = BehaviorSubject(value: 1)
        let _ = subject2.asDriver(onErrorJustReturn: 1)
            .trackActivity(activityIndicator)
            .drive()
        subject1.onCompleted()
        subject2.onCompleted()
        XCTAssertFalse(value)
    }
    
    func testEmitsFalseWhenTrackingObservablesAreDisposed_asDriver() {
        let activityIndicator = ActivityIndicator()
        var value = true
        let _ = activityIndicator.asDriver(onErrorJustReturn: false)
            .drive(onNext: { value = $0 })
        let disposable = Observable.just(1)
            .concat(Observable.never())
            .asDriver(onErrorJustReturn: 1)
            .trackActivity(activityIndicator)
            .drive()
        disposable.dispose()
        XCTAssertFalse(value)
    }
    
}
