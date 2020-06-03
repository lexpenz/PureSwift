//
//  AuthenticationService.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 24/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import LocalAuthentication

protocol AuthenticationService {
    func enableBiometric(onSuccess: @escaping ()->(), onError: @escaping ()->(), onNoBiomentic: @escaping ()->())
    func disableBiometric()
    func isBiometricEnabled() -> Bool
    func isBiometricAvailable() -> Bool
}

final class AuthenticationServiceImpl: AuthenticationService {

    // MARK: - UserDefaults keys

    private enum UserDefaultsKeys: String {
        case biometricEnabled
    }

    func enableBiometric(onSuccess: @escaping () -> (), onError: @escaping () -> (), onNoBiomentic: @escaping ()->()) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = NSLocalizedString("biometric.reason", comment: "")
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.biometricEnabled.rawValue)
                
                DispatchQueue.main.async {
                    if success {
                        onSuccess()
                    } else {
                        onError()
                    }
                }
            }
        } else {
            onNoBiomentic()
        }
    }

    func disableBiometric() {
        let context = LAContext()
        context.invalidate()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.biometricEnabled.rawValue)
    }

    func isBiometricEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.biometricEnabled.rawValue)
    }

    func isBiometricAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?

        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    }
}
