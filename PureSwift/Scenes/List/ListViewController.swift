//
//  ListViewController.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 23/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    weak var coordinator: MoviesListCoordinator?

    private(set) var tableView = UITableView()
    private let viewModel: MoviesListViewModel = MoviesListViewModelImpl()
    private let credentialsService: AuthenticationService = AuthenticationServiceImpl()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        layout()
    }

    private func setupUI() {
        tableView.tap {
            $0.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
        }
        tableView.delegate = self
        tableView.dataSource = self


        (viewModel as! MoviesListViewModelImpl).viewController = self


        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("logout.barButton", comment: ""), style: .done, target: self, action: #selector(logoutAction))

        let searchController = UISearchController(searchResultsController: nil)

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search.placeholder", comment: "")
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }

    private func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc func logoutAction() {
        credentialsService.disableBiometric()
        coordinator?.logout()
    }
}

// MARK: - TableView

extension ListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel.cellViewModelForRow(at: indexPath) else {
            return UITableViewCell()
        }

        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.reuseIdentifier,
                                                       for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }

        cell.update(with: viewModel)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }


}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(text: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.filter(text: "")
    }
}
