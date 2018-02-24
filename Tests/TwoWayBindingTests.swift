//
//  TwoWayBindingTests.swift
//  RxSwiftUtilities iOS
//
//  Created by Daichi Nakajima on 2018/02/24.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import XCTest
import RxSwiftUtilities
import RxSwift
import RxCocoa
import RxTest

final class PrimitiveMockObserver<ElementType> : ObserverType {
    typealias Element = ElementType

    var events: [Recorded<Event<Element>>]

    init() {
        self.events = []
    }

    func on(_ event: Event<Element>) {
        events.append(Recorded(time: 0, value: event))
    }
}


class TwoWayBindingTests: XCTestCase {
    let bag = DisposeBag()

    func testInitiallyEmitDataFromVariable() {
        let variable = Variable("start")
        let propertySubject = PublishSubject<String>()
        let changedObserver = PrimitiveMockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: propertySubject.asObserver(),
            valueSink: changedObserver
        )

        _ = controlProperty <-> variable

        XCTAssertEqual(changedObserver.events, [next(0, "start")])
    }

    func testInitiallyEmitDataFromControlProperty() {
        let variable = Variable("start")
        let propertySubject = PublishSubject<String>()
        let changedObserver = PrimitiveMockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: propertySubject.asObserver(),
            valueSink: changedObserver
        )

        _ = controlProperty <-> variable

        propertySubject.onNext("changed")
        XCTAssertEqual(variable.value, "changed")

    }

    func testChanged() {
        let variable = Variable("start")
        let propertySubject = PublishSubject<String>()
        let changedObserver = PrimitiveMockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: propertySubject.asObserver(),
            valueSink: changedObserver
        )

        _ = controlProperty <-> variable
        var events: [Recorded<Event<String>>] = [next(0, "start")]
        XCTAssertEqual(changedObserver.events, events)

        variable.value = "changed"
        events.append(next(0, "changed"))
        XCTAssertEqual(changedObserver.events, events)

        propertySubject.onNext("changed 2")
        events.append(next(0, "changed 2"))
        XCTAssertEqual(changedObserver.events, events)
        XCTAssertEqual(variable.value, "changed 2")

        propertySubject.onNext("changed 3")
        events.append(next(0, "changed 3"))
        XCTAssertEqual(changedObserver.events, events)
        XCTAssertEqual(variable.value, "changed 3")

        variable.value = "changed 4"
        events.append(next(0, "changed 4"))
        XCTAssertEqual(changedObserver.events, events)
        XCTAssertEqual(variable.value, "changed 4")

        propertySubject.onCompleted()
        variable.value = "changed 5"
        print(changedObserver.events)
    }
}
