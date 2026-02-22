//
//  CurrentCell.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import UIKit

final class CurrentCell: UICollectionViewCell {
    static let reuseId = "CurrentCell"

    private let temperatureLabel = UILabel()
    private let conditionLabel = UILabel()
    private let iconImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) { fatalError() }

    private func configure() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 16

        temperatureLabel.font = .systemFont(ofSize: 48, weight: .bold)
        temperatureLabel.textColor = .label
        temperatureLabel.textAlignment = .center

        conditionLabel.font = .systemFont(ofSize: 17)
        conditionLabel.textColor = .secondaryLabel
        conditionLabel.textAlignment = .center
        conditionLabel.lineBreakMode = .byTruncatingTail

        iconImageView.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [temperatureLabel, conditionLabel, iconImageView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            iconImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    func configure(with viewModel: CurrentSectionViewModel) {
        temperatureLabel.text = viewModel.temperatureText
        conditionLabel.text = viewModel.conditionText
    }
}
