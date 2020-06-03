//
//  MoviesListViewModel.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 23/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import Foundation
import UIKit

protocol MoviesListViewModel {
    var numberOfSections: Int { get }
    var viewController: ListViewController? { get set }

    func numberOfRows(in section: Int) -> Int
    func cellViewModelForRow(at indexPath: IndexPath) -> MovieCellViewModel?
    func filter(text: String)
    func logoutTapped()
}

final class MoviesListViewModelImpl: MoviesListViewModel {

    public weak var viewController: ListViewController?

    private(set) var cells: [MovieCellViewModel] = []
    private var filteredCells: [MovieCellViewModel] = []
    private var filterText = ""

    // MARK: - Services
    private let authenticationService: AuthenticationService
    private var networkService: NetworkService

    init(networkService: NetworkService, authenticationService: AuthenticationService) {
        self.networkService = networkService
        self.authenticationService = authenticationService

        networkService.getMovies(onSuccess: { [weak self] movies in
            guard let self = self else { return }

            self.cells = [MovieCellViewModel]()
            self.cells = self.generateCells(models: movies)

            if self.cells.isEmpty {
                self.viewController?.showNoDataAlert()
            }

            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }
        }, onError: { [weak self] error in
            guard let self = self else { return }

            self.viewController?.showNetworkErrorAlert()
        })
    }

    func logoutTapped() {
        authenticationService.disableBiometric()
    }

    func filter(text: String) {
        filterText = text.lowercased()
        filteredCells = cells.filter({ $0.title.lowercased().contains(filterText) })
    }
}

// MARK: - Generate Cells

extension MoviesListViewModelImpl {
    private func generateCells(models: [Movie]) -> [MovieCellViewModel] {
        var cells: [MovieCellViewModel] = []

        for movie in models {
            cells.append(MovieCellViewModel(title: movie.title, info: "\(movie.releaseYear)", imageUrl: movie.image, image: UIImage()))
        }

        return cells
    }
}

// MARK: - TableView

extension MoviesListViewModelImpl {
    var numberOfSections: Int {
        return 1
    }

    func numberOfRows(in section: Int) -> Int {
        if !filterText.isEmpty {
            return filteredCells.count
        }
        return cells.count
    }

    func cellViewModelForRow(at indexPath: IndexPath) -> MovieCellViewModel? {
        var cells = self.cells
        if !filterText.isEmpty {
            cells = filteredCells
        }

        guard indexPath.row < cells.count else {
            return nil
        }

        return cells[indexPath.row]
    }
}

