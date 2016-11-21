//
//  RxSwiftUtilitiesTestClass.swift
//  RxSwiftUtilities
//
//  Created by Jesse Farless on 11/21/16.
//  Copyright © 2016 solidcell. All rights reserved.
//

import Foundation
import RxSwift

public class RxSwiftUtilitiesTestClass {

    public init() { }

    public func message() -> String {
        var msg = "Error :("
        let _ = Observable.just("Success!")
            .subscribe(onNext: { msg = $0})
        return msg
    }

}
