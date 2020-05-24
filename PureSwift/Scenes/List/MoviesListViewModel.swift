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
    func numberOfRows(in section: Int) -> Int
    func cellViewModelForRow(at indexPath: IndexPath) -> MovieCellViewModel?
    func filter(text: String)

}

final class MoviesListViewModelImpl: MoviesListViewModel {

    private(set) var cells: [MovieCellViewModel] = []
    private var filteredCells: [MovieCellViewModel] = []
    public weak var viewController: ListViewController?
    private var filterText = ""
    private var networkService: NetworkService = NetworkServiceImpl()

    init() {
        networkService.getRequest(urlString: "https://api.androidhive.info/json/movies.json") { data in
            guard let models = data as? [[String: Any]] else { return }

            self.cells = [MovieCellViewModel]()
            var jsonModels = [Movie]()
            for model in models {
                jsonModels.append(try! Movie(json: model))
            }
            self.cells = self.generateCells(models: jsonModels)

            DispatchQueue.main.async {
                self.viewController?.tableView.reloadData()
            }

        }
    }

    func filter(text: String) {
        filterText = text
        filteredCells = cells.filter({ $0.title.contains(text) })
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

