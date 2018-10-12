//
//  ActivityIndicatorViewController.swift
//  ExampleApp
//
//  Created by Jesse Farless on 11/22/16.
//  Copyright © 2016 RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftUtilities

class ActivityIndicatorViewController: UITableViewController {

    @IBOutlet private weak var switch1: UISwitch!
    @IBOutlet private weak var switch2: UISwitch!
    @IBOutlet private weak var switch3: UISwitch!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var valueCell: UITableViewCell!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let activityIndicator = ActivityIndicator()

        // These Observables represent some activity
        // Ex. network activity, task processing, etc.
        [switch1, switch2, switch3].forEach { switchControl in
            createActivityObservable(switchControl: switchControl, activityIndicator: activityIndicator)
                .subscribe()
                .disposed(by: disposeBag)
        }

        // This will drive the UILabel in the view controller
        activityIndicator.asDriver()
            .map { String(describing: $0) }
            .drive(valueCell.textLabel!.rx.text)
            .disposed(by: disposeBag)

        // This will drive a UIActivityIndicatorView in the view controller
        activityIndicator.asDriver()
            .drive(activityIndicatorView.rx.isAnimating)
            .disposed(by: disposeBag)

        // This will drive the Network Activity Indicator in the status bar
        activityIndicator.asDriver()
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
    }

    private func createActivityObservable(switchControl: UISwitch,
                                          activityIndicator: ActivityIndicator) -> Observable<Void> {
        return switchControl.rx.value.asObservable()
            .flatMapLatest { (isOn: Bool) -> Observable<Void> in
                if isOn {
                    return Observable<Void>.never()
                        .trackActivity(activityIndicator)
                } else {
                    return Observable<Void>.empty()
                        .trackActivity(activityIndicator)
                }
        }
    }
}
