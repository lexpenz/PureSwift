//
//  CredentialsView.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 22/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

class CredentialsView: UIView {

    private(set) var loginTextField = UITextField()
    private(set) var passwordTextField = UITextField()

    
    init() {
        super.init(frame: .zero)

        setupUI()
        layout()
    }

    private func setupUI() {
        backgroundColor = .lightGray

        loginTextField.tintColor = .black
        passwordTextField.tintColor = .black

        loginTextField.placeholder = NSLocalizedString("loginField.placeholder", comment: "")
        passwordTextField.placeholder = NSLocalizedString("passwordField.placeholder", comment: "")
        passwordTextField.isSecureTextEntry = true

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
            loginTextField.topAnchor.constraint(equalTo: topAnchor),
            loginTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 32),
            passwordTextField.widthAnchor.constraint(equalToConstant: 200),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 56),
            passwordTextField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
