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
}

protocol LoginCoordinator: Coordinator {
    func login()
}

protocol MoviesListCoordinator: Coordinator {
    func logout()
}

final class AppCoordinator: Coordinator {
    private var navigationController: UINavigationController!

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let authenticationService = AuthenticationServiceImpl()
        let credentialsService = CredentialsServiceImpl()
        let viewModel = LoginViewModelImpl(authenticationService: authenticationService, credentialsService: credentialsService)

        let viewController = LoginViewController(viewModel: viewModel)
        viewController.coordinator = self
        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: LoginCoordinator {
    func login() {
        let networkService = NetworkServiceImpl()
        let authenticationService = AuthenticationServiceImpl()
        let viewModel = MoviesListViewModelImpl(networkService: networkService, authenticationService: authenticationService)

        let viewController = ListViewController(viewModel: viewModel)
        viewController.coordinator = self
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

extension AppCoordinator: MoviesListCoordinator {
    func logout() {
        let authenticationService = AuthenticationServiceImpl()
        let credentialsService = CredentialsServiceImpl()
        let viewModel = LoginViewModelImpl(authenticationService: authenticationService, credentialsService: credentialsService)

        let viewController = LoginViewController(viewModel: viewModel)
        viewController.coordinator = self

        window.rootViewController = viewController
        window.makeKeyAndVisible()
    }
}
