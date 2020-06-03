//
//  LabelSwitchView.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 22/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

final class LabelSwitchView: UIView {
    
    private let textLabel = UILabel()
    private(set) var switchControl = UISwitch()

    init() {
        super.init(frame: .zero)

        setupUI()
        layout()
    }

    private func setupUI() {
        textLabel.text = NSLocalizedString("touchId.label", comment: "")
    }

    private func layout() {
        addSubview(textLabel)
        addSubview(switchControl)

        translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        switchControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: switchControl.leadingAnchor),
            textLabel.topAnchor.constraint(equalTo: topAnchor),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            switchControl.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -16),
            switchControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
