//
//  ErrorTracker.swift
//  Pods-ExampleApp
//
//  Created by Rafael Ferreira on 11/14/18.
//

import RxCocoa
import RxSwift

extension ObservableConvertibleType {
    public func trackError<T>(_ tracker: T) -> Observable<Self.E> where T: ObserverType, T.E == Error {
        return asObservable().do(onError: { error in
            tracker.onNext(error)
        })
    }

    public func trackError<T>(_ tracker: T) -> Observable<Self.E> where T: PublishRelay<Error> {
        return asObservable().do(onError: { error in
            tracker.accept(error)
        })
    }
}
