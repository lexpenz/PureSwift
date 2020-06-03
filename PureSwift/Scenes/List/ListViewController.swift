//
//  ListViewController.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 23/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController, AlertShowable {

    weak var coordinator: MoviesListCoordinator?
    private var viewModel: MoviesListViewModel

    // MARK: - UI

    private(set) var tableView = UITableView()

    init(viewModel: MoviesListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "ListView"

        viewModel.viewController = self

        setupUI()
        layout()
        setupActions()
    }

    private func setupUI() {
        view.backgroundColor = .white
        definesPresentationContext = true
        
        tableView.tap {
            $0.register(MovieCell.self, forCellReuseIdentifier: MovieCell.reuseIdentifier)
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
        }

        let searchController = UISearchController(searchResultsController: nil)
        searchController.tap {
            $0.searchResultsUpdater = self
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchBar.placeholder = NSLocalizedString("search.placeholder", comment: "")
            $0.searchBar.delegate = self
        }

        navigationItem.searchController = searchController
    }

    private func layout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupActions() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: NSLocalizedString("logout.barButton", comment: ""), style: .done, target: self, action: #selector(logoutAction))
    }
}

// MARK: - Action handlers

extension ListViewController {
    @objc func logoutAction() {
        viewModel.logoutTapped()
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
        return 100
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
