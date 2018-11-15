//
//  ErrorTracker.swift
//  Pods-ExampleApp
//
//  Created by Rafael Ferreira on 11/14/18.
//

import RxCocoa
import RxSwift

/**
 Enables monitoring of errors's throw in sequence computation.
 */
public final class ErrorTracker: SharedSequenceConvertibleType {
    public typealias E = Error
    public typealias SharingStrategy = DriverSharingStrategy

    private let _subject = PublishRelay<E>()
    private let _errors: SharedSequence<SharingStrategy, E>

    // MARK: Initializer

    public init() {
        _errors = _subject.asDriver(onErrorDriveWith: SharedSequence.empty())
    }

    // MARK: SharedSequenceConvertibleType conforms

    public func asSharedSequence() -> SharedSequence<SharingStrategy, ErrorTracker.E> {
        return _errors
    }

    // MARK: Fileprivate functions

    fileprivate func trackErrorOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.E> {
        return source.asObservable().do(onError: { [weak self] error in
            self?.onError(error: error)
        })
    }

    private func onError(error: Error) {
        _subject.accept(error)
    }
}

extension ObservableConvertibleType {
    public func trackError(_ errorTracker: ErrorTracker) -> Observable<E> {
        return errorTracker.trackErrorOfObservable(self)
    }
}
