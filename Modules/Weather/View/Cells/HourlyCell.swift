//
//  HourlyCell.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//

import UIKit

final class HourlyCell: UICollectionViewCell {

    static let reuseId = "HourlyCell"

    private let timeLabel = UILabel()
    private let iconImageView = UIImageView()
    private let tempLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func configure() {

        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 12

        timeLabel.font = .systemFont(ofSize: 14)
        timeLabel.textColor = .secondaryLabel
        timeLabel.textAlignment = .center

        tempLabel.font = .systemFont(ofSize: 16, weight: .medium)
        tempLabel.textAlignment = .center

        iconImageView.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [
            timeLabel,
            iconImageView,
            tempLabel
        ])

        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            iconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(with viewModel: HourlyItemViewModel) {
        timeLabel.text = viewModel.timeText
        tempLabel.text = viewModel.temperatureText
    }
}
