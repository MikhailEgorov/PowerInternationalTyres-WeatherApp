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

        minMaxLabel.font = .systemFont(ofSize: 16)
        minMaxLabel.textColor = .secondaryLabel
        minMaxLabel.textAlignment = .right

        iconImageView.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [
            dayLabel,
            iconImageView,
            minMaxLabel
        ])

        stack.axis = .horizontal
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false

        iconImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])

        minMaxLabel.setContentHuggingPriority(.required, for: .horizontal)
        dayLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    func configure(with viewModel: ForecastItemViewModel) {
        dayLabel.text = viewModel.dayText
        minMaxLabel.text = viewModel.minMaxText
    }
}
