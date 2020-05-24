//
//  ViewController.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 20/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    weak var coordinator: LoginCoordinator?

    private let contentStackView = UIStackView()
    private let credentialsView = CredentialsView()
    private let touchIdView = LabelSwitchView(viewModel: SwitchSettingViewModelImpl())
    private let button = UIButton(type: .system)

    private let authenticationService: AuthenticationService = AuthenticationServiceImpl()
    private let credentialsService: CredentialsService = CredentialsServiceImpl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        layout()

        if authenticationService.isBiometricEnabled() {
            credentialsView.loginTextField.text = credentialsService.getLastLogin()
            authenticateWithBiometric()
        }
    }

    private func setupUI() {
        view.backgroundColor = .white


        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = 32
        contentStackView.addArrangedSubview(credentialsView)
        contentStackView.addArrangedSubview(touchIdView)



        button.setTitle(NSLocalizedString("login.button", comment: ""), for: .normal)
        button.backgroundColor = .orange


        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        touchIdView.switchControl.isOn = authenticationService.isBiometricEnabled()
        self.hideKeyboardWhenTappedAround()
    }

    private func layout() {
        view.addSubview(contentStackView)
        view.addSubview(button)

        credentialsView.translatesAutoresizingMaskIntoConstraints = false
        touchIdView.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 56),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: contentStackView.bottomAnchor, constant: 50),
        ])
    }

    @objc private func buttonTapped() {
        if checkCredentials(login: credentialsView.loginTextField.text!, password: credentialsView.passwordTextField.text!) {
            credentialsService.saveLast(login: credentialsView.loginTextField.text!)
            authenticateWithBiometric()
        } else {
            authenticationService.disableBiometric()
            self.touchIdView.switchControl.isOn = false
        }
    }

    private func authenticateWithBiometric() {
        authenticationService.enableBiometric(onSuccess: { [weak self] in
                self?.touchIdView.switchControl.isOn = true
                self?.coordinator?.login()
            }, onError: {
                print("Error")
            }) {  [weak self] in
                self?.coordinator?.login()
            }
    }

    private func checkCredentials(login: String, password: String) -> Bool {
        return credentialsService.checkCredentials(login: login, password: password)
    }
}
