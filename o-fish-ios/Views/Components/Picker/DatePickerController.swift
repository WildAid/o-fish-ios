//
//  DatePickerController.swift
//
//  Created on 21.03.2022.
//  Copyright © 2022 WildAid. All rights reserved.
//

import UIKit
import SwiftUI

class DatePickerController: UIViewController {
    /// 2 pickers due to background color issue in SwiftUI
    private(set) lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .inline
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 15.0
        picker.clipsToBounds = true
        picker.isHidden = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private(set) lazy var timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .time
        picker.preferredDatePickerStyle = .wheels
        picker.backgroundColor = .white
        picker.layer.cornerRadius = 15.0
        picker.clipsToBounds = true
        picker.isHidden = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    private(set) lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.addSubview(blurView)
        view.addSubview(datePicker)
        view.addSubview(timePicker)

        let pickerWidth: CGFloat = 280

        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            datePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            datePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            datePicker.widthAnchor.constraint(equalToConstant: pickerWidth),

            timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.widthAnchor.constraint(equalToConstant: pickerWidth)
        ])
    }
}

struct DatePickerView: UIViewRepresentable {
    var date: Date
    var mode: UIDatePicker.Mode
    var completion: (Date) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    func makeUIView(context: Context) -> UIView {
        let vc = DatePickerController()
        addCompletionGesture(for: vc.blurView, context: context)
        configureDatePicker(for: vc, context: context)
        return vc.view
    }

    func updateUIView(_ view: UIView, context: Context) {
        context.coordinator.handler = completion
    }

    private func configureDatePicker(for vc: DatePickerController, context: Context) {
        if mode == .time {
            vc.timePicker.date = date
            vc.timePicker.isHidden = false
            vc.timePicker.addTarget(context.coordinator,
                                           action: #selector(Coordinator.timePickerHandler),
                                           for: .valueChanged)

        } else {
            vc.datePicker.date = date
            vc.datePicker.datePickerMode = mode
            vc.datePicker.isHidden = false
            vc.datePicker.addTarget(context.coordinator,
                                    action: #selector(Coordinator.datePickerHandler),
                                    for: .valueChanged)
        }
    }

    private func addCompletionGesture(for view: UIView, context: Context) {
        let tap = UITapGestureRecognizer(target: context.coordinator,
                                         action: #selector(Coordinator.tapHandler))
        view.addGestureRecognizer(tap)
    }

}

extension DatePickerView {

    class Coordinator {
        var handler: ((Date) -> Void)?
        var date = Date()

        @objc
        func datePickerHandler(_ sender: UIDatePicker) {
            date = sender.date
            handler?(sender.date)
        }

        @objc
        func timePickerHandler(_ sender: UIDatePicker) {
            date = sender.date
        }

        @objc
        func tapHandler() {
            handler?(date)
        }
    }

}
