//
//  TwoWayBinding.swift
//  RxSwiftUtilities
//
//  Created by Krunoslav Zaher on 12/6/15.
//  Copyright © 2015 Krunoslav Zaher. All rights reserved.
//
//  This file was copied from RxSwift's example app:
//  https://github.com/ReactiveX/RxSwift/blob/32b07fc/RxExample/RxExample/Operators.swift
//

import RxSwift
import RxCocoa
import UIKit

// Two way binding operator between control property and behaviorRelay, that's all it takes

infix operator <-> : DefaultPrecedence

private func nonMarkedText(_ textInput: UITextInput) -> String? {
    let start = textInput.beginningOfDocument
    let end = textInput.endOfDocument

    guard let rangeAll = textInput.textRange(from: start, to: end),
        let text = textInput.text(in: rangeAll) else {
            return nil
    }

    guard let markedTextRange = textInput.markedTextRange else {
        return text
    }

    guard let startRange = textInput.textRange(from: start, to: markedTextRange.start),
        let endRange = textInput.textRange(from: markedTextRange.end, to: end) else {
            return text
    }

    return (textInput.text(in: startRange) ?? "") + (textInput.text(in: endRange) ?? "")
}

public func <-> <Base>(textInput: TextInput<Base>, behaviorRelay: BehaviorRelay<String>) -> Disposable {
    let bindToUIDisposable = behaviorRelay.asObservable()
        .bind(to: textInput.text)
    let bindToBehaviorRelay = textInput.text
        .subscribe(onNext: { [weak base = textInput.base] n in
            guard let base = base else {
                return
            }

            let nonMarkedTextValue = nonMarkedText(base)

            /**
             In some cases `textInput.textRangeFromPosition(start, toPosition: end)` will return nil even though the underlying
             value is not nil. This appears to be an Apple bug. If it's not, and we are doing something wrong, please let us know.
             The can be reproed easily if replace bottom code with

             if nonMarkedTextValue != behaviorRelay.value {
             behaviorRelay.accept(nonMarkedTextValue ?? "")
             }

             and you hit "Done" button on keyboard.
             */
            if let nonMarkedTextValue = nonMarkedTextValue, nonMarkedTextValue != behaviorRelay.value {
                behaviorRelay.accept(nonMarkedTextValue)
            }
            }, onCompleted:  {
                bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToBehaviorRelay)
}

/// When binding `rx.text`, be warned that for languages that use IME, intermediate results might be returned while text is being inputed.
/// REMEDY: Just use `textField <-> behaviorRelay` instead of `textField.rx.text <-> behaviorRelay`.
/// Find out more here: https://github.com/ReactiveX/RxSwift/issues/649
public func <-> <T>(property: ControlProperty<T>, behaviorRelay: BehaviorRelay<T>) -> Disposable {

    let bindToUIDisposable = behaviorRelay.asObservable()
        .bind(to: property)
    let bindToBehaviorRelay = property
        .subscribe(onNext: { n in
            behaviorRelay.accept(n)
        }, onCompleted: {
            bindToUIDisposable.dispose()
        })

    return Disposables.create(bindToUIDisposable, bindToBehaviorRelay)
}
