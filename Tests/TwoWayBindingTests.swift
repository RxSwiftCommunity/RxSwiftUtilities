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

private class TwoWayBindingTests: XCTestCase {

    func testNoInitialControlPropertyValue() {
        let bag = DisposeBag()
        let variable = Variable("start")
        let controlValues = PublishSubject<String>()
        let controlSink = MockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: controlValues,
            valueSink: controlSink
        )

        XCTAssertEqual(variable.value, "start")
        XCTAssertEqual(controlSink.events, [])

        (controlProperty <-> variable)
            .disposed(by: bag)

        XCTAssertEqual(variable.value, "start")
        XCTAssertEqual(controlSink.events, [Event.next("start")])
    }

    func testWithInitialControlPropertyValue() {
        let bag = DisposeBag()
        let variable = Variable("start variable")
        let controlValues = BehaviorSubject<String>(value: "start control")
        let controlSink = MockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: controlValues,
            valueSink: controlSink
        )

        XCTAssertEqual(variable.value, "start variable")
        XCTAssertEqual(controlSink.events, [])

        (controlProperty <-> variable)
            .disposed(by: bag)

        XCTAssertEqual(variable.value, "start control")
        XCTAssertEqual(controlSink.events, [Event.next("start variable"),
                                            Event.next("start control")])
    }

    func testChanged() {
        let bag = DisposeBag()
        let variable = Variable("start")
        let controlValues = PublishSubject<String>()
        let controlSink = MockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: controlValues,
            valueSink: controlSink
        )

        (controlProperty <-> variable)
            .disposed(by: bag)

        variable.value = "changed"

        XCTAssertEqual(variable.value, "changed")
        XCTAssertEqual(controlSink.events, [Event.next("start"),
                                            .next("changed")])

        controlValues.onNext("changed 2")

        XCTAssertEqual(controlSink.events, [Event.next("start"),
                                            .next("changed"),
                                            .next("changed 2")])
        XCTAssertEqual(variable.value, "changed 2")

        variable.value = "changed 3"

        XCTAssertEqual(controlSink.events, [Event.next("start"),
                                            .next("changed"),
                                            .next("changed 2"),
                                            .next("changed 3")])
    }

    func testTextInput() {
        let bag = DisposeBag()
        let textField = UITextField()
        let variable = Variable("start")

        (textField.rx.textInput <-> variable)
            .disposed(by: bag)

        XCTAssertEqual(textField.text, "start")
    }
}

private class MockObserver<ElementType>: ObserverType {

    typealias Element = ElementType

    private(set) var events: [Event<Element>] = []

    func on(_ event: Event<Element>) {
        events.append(event)
    }
}
