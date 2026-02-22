//
//  ForecastCell.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import UIKit

final class ForecastCell: UICollectionViewCell {
    static let reuseId = "ForecastCell"

    private let dayLabel = UILabel()
    private let iconImageView = UIImageView()
    private let minMaxLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func configure() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12

        dayLabel.font = .systemFont(ofSize: 16, weight: .medium)
        dayLabel.textColor = .label
        dayLabel.numberOfLines = 1
        dayLabel.textAlignment = .left
        dayLabel.lineBreakMode = .byTruncatingTail

        minMaxLabel.font = .systemFont(ofSize: 16, weight: .medium)
        minMaxLabel.textColor = .label
        minMaxLabel.textAlignment = .right
        minMaxLabel.numberOfLines = 1

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.setContentHuggingPriority(.required, for: .horizontal)
        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        let topStack = UIStackView(arrangedSubviews: [dayLabel, iconImageView])
        topStack.axis = .horizontal
        topStack.spacing = 8
        topStack.alignment = .center
        topStack.translatesAutoresizingMaskIntoConstraints = false

        let bottomStack = UIStackView(arrangedSubviews: [minMaxLabel])
        bottomStack.axis = .horizontal
        bottomStack.alignment = .center
        bottomStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [topStack, bottomStack])
        mainStack.axis = .vertical
        mainStack.spacing = 4
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(mainStack)

        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            mainStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    func configure(with viewModel: ForecastItemViewModel) {
        dayLabel.text = viewModel.dayText
        minMaxLabel.text = viewModel.minMaxText
    }
}
