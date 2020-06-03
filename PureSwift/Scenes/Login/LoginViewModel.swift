//
//  LoginViewModel.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 03/06/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import Foundation
import LocalAuthentication

protocol LoginViewModel {
    func viewDidLoad()
    func loginTapped(login: String?, password: String?)

    var lastLogin: String { get }
    var isBiometricEnabled: Bool { get }
    var isBiometricAvailable: Bool { get }

    var onBiometricLoginSuccess: (()->())? { get set}
    var onBiometricFail: (()->())? { get set }
    var onLoginSuccess: (()->())? { get set }
    var onLoginFail: (()->())? { get set }
}

final class LoginViewModelImpl: LoginViewModel {

    // MARK: - Callbacks
    var onBiometricLoginSuccess: (() -> ())?
    var onBiometricFail: (() -> ())?
    var onLoginSuccess: (() -> ())?
    var onLoginFail: (() -> ())?

    // MARK: - Services
    private let authenticationService: AuthenticationService
    private let credentialsService: CredentialsService

    var lastLogin: String {
        credentialsService.getLastLogin()
    }

    var isBiometricEnabled: Bool {
        authenticationService.isBiometricEnabled()
    }

    var isBiometricAvailable: Bool {
        authenticationService.isBiometricAvailable()
    }

    init(authenticationService: AuthenticationService, credentialsService: CredentialsService) {
        self.authenticationService = authenticationService
        self.credentialsService = credentialsService
    }

    func viewDidLoad() {
        if authenticationService.isBiometricEnabled() {
            authenticateWithBiometric()
        }
    }

    func loginTapped(login: String?, password: String?) {
        guard let login = login,
              let password = password
        else { return }

        if credentialsService.checkCredentials(login: login, password: password) {
            credentialsService.saveLast(login: login)
            if isBiometricAvailable {
                authenticateWithBiometric()
            } else {
                onLoginSuccess?()
            }
        } else {
            authenticationService.disableBiometric()
            onLoginFail?()
        }
    }

    private func authenticateWithBiometric() {
        authenticationService.enableBiometric(onSuccess: { [weak self] in
            self?.onBiometricLoginSuccess?()
        }, onError: { [weak self] in
            self?.onBiometricFail?()
        }, onNoBiomentic: { [weak self] in
            self?.onLoginFail?()
        })
    }
}
