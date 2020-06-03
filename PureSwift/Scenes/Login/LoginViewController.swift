//
//  ViewController.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 20/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, AlertShowable {
    weak var coordinator: LoginCoordinator?
    private var viewModel: LoginViewModel
    
    // MARK: - UI

    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()
    private let credentialsView = CredentialsView()
    private let touchIdView = LabelSwitchView()

    private var scrollViewBottomConstraint: NSLayoutConstraint!
    private var centerConstaint: NSLayoutConstraint!

    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        layout()
        setupActions()

        if viewModel.isBiometricEnabled {
            credentialsView.loginTextField.text = viewModel.lastLogin
        }

        viewModel.viewDidLoad()
    }

    private func setupUI() {
        view.backgroundColor = Appearance.Colors.whiteBackground

        contentStackView.tap {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.distribution = .equalSpacing
            $0.spacing = 32
        }

        scrollView.keyboardDismissMode = .onDrag

        touchIdView.switchControl.isOn = viewModel.isBiometricEnabled

        credentialsView.passwordTextField.returnKeyType = .continue

        hideKeyboardWhenTappedAround()
    }

    private func layout() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(credentialsView)
        contentStackView.addArrangedSubview(touchIdView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        credentialsView.translatesAutoresizingMaskIntoConstraints = false
        touchIdView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])

        if let contentStackViewSuperview = contentStackView.superview {
            NSLayoutConstraint.activate([
                contentStackView.leadingAnchor.constraint(equalTo: contentStackViewSuperview.leadingAnchor),
                contentStackView.trailingAnchor.constraint(equalTo: contentStackViewSuperview.trailingAnchor),
                contentStackView.topAnchor.constraint(greaterThanOrEqualTo: contentStackViewSuperview.topAnchor),
                contentStackView.bottomAnchor.constraint(equalTo: contentStackViewSuperview.bottomAnchor),
                contentStackView.widthAnchor.constraint(equalTo: contentStackViewSuperview.widthAnchor),
                contentStackView.heightAnchor.constraint(lessThanOrEqualTo: contentStackViewSuperview.heightAnchor),
            ])

            centerConstaint = contentStackView.centerYAnchor.constraint(lessThanOrEqualTo: contentStackViewSuperview.centerYAnchor)
            centerConstaint.priority = UILayoutPriority(rawValue: 750)
            centerConstaint.isActive = true
        }

        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        scrollViewBottomConstraint.priority = UILayoutPriority(rawValue: 500)
        scrollViewBottomConstraint.isActive = true
    }

    private func setupActions() {
        credentialsView.loginTextField.addTarget(self, action: #selector(loginTextFieldEnter), for: .editingDidEndOnExit)
        credentialsView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldEnter), for: .editingDidEndOnExit)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        viewModel.onBiometricLoginSuccess = { [weak self] in
            self?.touchIdView.switchControl.isOn = true
            self?.coordinator?.login()
        }

        viewModel.onLoginSuccess = { [weak self] in
            self?.coordinator?.login()
        }

        viewModel.onLoginFail = { [weak self] in
            self?.touchIdView.switchControl.isOn = false
            self?.showLoginFailedAlert()
        }
    }

    @objc private func buttonTapped() {
        viewModel.loginTapped(login: credentialsView.loginTextField.text, password: credentialsView.passwordTextField.text)
    }

    @objc private func loginTextFieldEnter() {
        credentialsView.passwordTextField.becomeFirstResponder()
    }

    @objc private func passwordTextFieldEnter() {
        buttonTapped()
    }

    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                scrollViewBottomConstraint.constant = -keyboardSize.height
                UIView.animate(withDuration: 0.3) { [weak self] in
                    self?.view.layoutIfNeeded()
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
}
