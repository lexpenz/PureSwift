//
//  MovieCell.swift
//  PureSwift
//
//  Created by Aleksei Penzentcev on 21/05/2020.
//  Copyright © 2020 Aleksei Penzentcev. All rights reserved.
//

import UIKit

final class MovieCell: UITableViewCell, ReusableView {

    // MARK: - UI
    
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let infoLabel = UILabel()
    private let labelsStackView = UIStackView()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none

        logoImageView.contentMode = .scaleAspectFill
        logoImageView.layer.cornerRadius = 5
        logoImageView.clipsToBounds = true

        labelsStackView.axis = .vertical
        labelsStackView.spacing = 8

        titleLabel.adjustsFontSizeToFitWidth = true

        layout()
    }

    private func layout() {
        addSubview(logoImageView)
        addSubview(labelsStackView)

        labelsStackView.addArrangedSubview(titleLabel)
        labelsStackView.addArrangedSubview(infoLabel)

        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor),
            logoImageView.widthAnchor.constraint(lessThanOrEqualToConstant: 100)
        ])

        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            labelsStackView.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 16),
            labelsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelsStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: - Update

extension MovieCell {
    func update(with viewModel: MovieCellViewModel) {
        titleLabel.text = viewModel.title
        infoLabel.text = viewModel.info
        logoImageView.image = viewModel.image
    }
}
