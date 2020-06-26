//
//  TwoWayBindingViewController.swift
//  ExampleApp
//
//  Created by Jesse Farless on 10/8/18.
//  Copyright © 2018 RxSwiftCommunity. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxSwiftUtilities

class TwoWayBindingViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var stackView: UIStackView!

    private let behaviorRelay = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        let tableView = self.tableView!
        let stackView = self.stackView!

        tableView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.interactive
        tableView.alwaysBounceVertical = false

        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done

        NotificationCenter.default.rx.notification(UIResponder.keyboardDidShowNotification)
            .subscribe(onNext: { _ in
                var rect = tableView.convert(stackView.frame, from: stackView)
                rect = CGRect(x: rect.minX, y: rect.minY + 20, width: rect.width, height: rect.height)
                tableView.scrollRectToVisible(rect, animated: true)
            })
            .disposed(by: disposeBag)

        (textField.rx.text <-> behaviorRelay)
            .disposed(by: disposeBag)

        behaviorRelay
            .asDriver()
            .drive(label.rx.text)
            .disposed(by: disposeBag)

        stackView.distribution = .equalCentering

        ["🦆", "🥐", "🚒", "🍻", "🌻"].forEach { text in
            let button = UIButton(type: UIButton.ButtonType.system)
            button.setTitle(text, for: UIControl.State.normal)
            stackView.addArrangedSubview(button)
            button.rx.tap
                .asDriver()
                .map { button.titleLabel?.text }
                .drive(behaviorRelay)
                .disposed(by: disposeBag)
            button.backgroundColor = UIColor(displayP3Red: 0.93, green: 0.93, blue: 0.93, alpha: 1)
            button.layer.cornerRadius = 4
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
