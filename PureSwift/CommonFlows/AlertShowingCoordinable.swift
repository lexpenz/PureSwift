//
//  AlertShowingCoordinable.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 02/06/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

protocol AlertShowable: class {
    func showLoginFailedAlert()
    func showNetworkErrorAlert()
    func showNoDataAlert()
}

extension AlertShowable where Self: UIViewController {
    func showLoginFailedAlert() {
        let alert = UIAlertController(title: NSLocalizedString("alert.loginFailed.title", comment: ""),
                                      message: NSLocalizedString("alert.loginFailed.message", comment: ""),
                                      preferredStyle: .alert)

        alert.addAction(.init(title: NSLocalizedString("alert.button.ok", comment: ""), style: .cancel))
        present(alert, animated: true)
    }

    func showNetworkErrorAlert() {
        let alert = UIAlertController(title: NSLocalizedString("alert.networkError.title", comment: ""),
                                      message: NSLocalizedString("alert.networkError.message", comment: ""),
                                      preferredStyle: .alert)

        alert.addAction(.init(title: NSLocalizedString("alert.button.ok", comment: ""), style: .cancel))
        present(alert, animated: true)
    }

    func showNoDataAlert() {
        let alert = UIAlertController(title: NSLocalizedString("alert.noData.title", comment: ""),
                                      message: NSLocalizedString("alert.noData.message", comment: ""),
                                      preferredStyle: .alert)

        alert.addAction(.init(title: NSLocalizedString("alert.button.ok", comment: ""), style: .cancel))
        present(alert, animated: true)
    }
}
