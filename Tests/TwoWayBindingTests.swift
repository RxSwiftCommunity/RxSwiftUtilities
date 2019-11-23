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
        let behaviorRelay = BehaviorRelay(value: "start")
        let controlValues = PublishSubject<String>()
        let controlSink = MockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: controlValues,
            valueSink: controlSink
        )

        XCTAssertEqual(behaviorRelay.value, "start")
        XCTAssertEqual(controlSink.events, [])

        (controlProperty <-> behaviorRelay)
            .disposed(by: bag)

        XCTAssertEqual(behaviorRelay.value, "start")
        XCTAssertEqual(controlSink.events, [Event.next("start")])
    }

    func testWithInitialControlPropertyValue() {
        let bag = DisposeBag()
        let behaviorRelay = BehaviorRelay(value: "start behaviorRelay")
        let controlValues = BehaviorSubject<String>(value: "start control")
        let controlSink = MockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: controlValues,
            valueSink: controlSink
        )

        XCTAssertEqual(behaviorRelay.value, "start behaviorRelay")
        XCTAssertEqual(controlSink.events, [])

        (controlProperty <-> behaviorRelay)
            .disposed(by: bag)

        XCTAssertEqual(behaviorRelay.value, "start control")
        XCTAssertEqual(controlSink.events, [Event.next("start behaviorRelay"),
                                            Event.next("start control")])
    }

    func testChanged() {
        let bag = DisposeBag()
        let behaviorRelay = BehaviorRelay(value: "start")
        let controlValues = PublishSubject<String>()
        let controlSink = MockObserver<String>()
        let controlProperty = ControlProperty<String>(
            values: controlValues,
            valueSink: controlSink
        )

        (controlProperty <-> behaviorRelay)
            .disposed(by: bag)

        behaviorRelay.accept("changed")

        XCTAssertEqual(behaviorRelay.value, "changed")
        XCTAssertEqual(controlSink.events, [Event.next("start"),
                                            .next("changed")])

        controlValues.onNext("changed 2")

        XCTAssertEqual(controlSink.events, [Event.next("start"),
                                            .next("changed"),
                                            .next("changed 2")])
        XCTAssertEqual(behaviorRelay.value, "changed 2")

        behaviorRelay.accept("changed 3")

        XCTAssertEqual(controlSink.events, [Event.next("start"),
                                            .next("changed"),
                                            .next("changed 2"),
                                            .next("changed 3")])
    }

    func testTextInput() {
        let bag = DisposeBag()
        let textField = UITextField()
        let behaviorRelay = BehaviorRelay(value: "start")

        (textField.rx.textInput <-> behaviorRelay)
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
