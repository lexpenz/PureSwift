//
//  AppCoordinator.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 24/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    func start()
    func showAlert()
}

protocol LoginCoordinator: Coordinator {
    func login()
}

protocol MoviesListCoordinator: Coordinator {
    func logout()
}

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController!

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let vc = LoginViewController()
        vc.coordinator = self
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }

    func showAlert() {

    }

}

extension AppCoordinator: LoginCoordinator {
    func login() {
        let vc = ListViewController()
        vc.coordinator = self
        let navigationController = UINavigationController(rootViewController: vc)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: MoviesListCoordinator {
    func logout() {
        let vc = LoginViewController()
        vc.coordinator = self

        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
}
