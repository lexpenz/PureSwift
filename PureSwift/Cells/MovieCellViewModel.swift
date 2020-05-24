//
//  MovieCellViewModel.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 21/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

final class MovieCellViewModel {
    let title: String
    let info: String
    let imageUrl: String
    var image: UIImage

    private let networkService: NetworkService = NetworkServiceImpl()

    init(title: String, info: String, imageUrl: String, image: UIImage?) {
        self.title = title
        self.info = info
        self.imageUrl = imageUrl
        self.image = image ?? UIImage()

        networkService.downloadImage(from: URL(string: imageUrl)!) { img in
            self.image = img
        }
    }
}
