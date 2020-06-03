//
//  CredentialsView.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 22/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

final class CredentialsView: UIView {

    private(set) var loginTextField = UITextField()
    private(set) var passwordTextField = UITextField()

    init() {
        super.init(frame: .zero)

        setupUI()
        layout()
    }

    private func setupUI() {
        backgroundColor = Appearance.Colors.lightBackground
        layer.cornerRadius = 5

        loginTextField.tap {
            $0.textColor = Appearance.Colors.darkText
            $0.tintColor = Appearance.Colors.lightText
            $0.accessibilityIdentifier = "loginTextField"
            $0.placeholder = NSLocalizedString("loginField.placeholder", comment: "")
        }

        passwordTextField.tap {
            $0.textColor = Appearance.Colors.darkText
            $0.tintColor = Appearance.Colors.lightText
            $0.accessibilityIdentifier = "passwordTextField"
            $0.placeholder = NSLocalizedString("passwordField.placeholder", comment: "")
            $0.isSecureTextEntry = true
        }

        loginTextField.becomeFirstResponder()
    }

    private func layout() {
        addSubview(loginTextField)
        addSubview(passwordTextField)

        translatesAutoresizingMaskIntoConstraints = false
        loginTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            loginTextField.widthAnchor.constraint(equalToConstant: 200),
            loginTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            loginTextField.heightAnchor.constraint(equalToConstant: 56),
            loginTextField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            loginTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
