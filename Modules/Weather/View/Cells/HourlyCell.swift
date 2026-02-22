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

        timeLabel.font = .systemFont(ofSize: 14, weight: .medium)
        timeLabel.textColor = .label
        timeLabel.textAlignment = .center
        timeLabel.lineBreakMode = .byTruncatingTail

        tempLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        tempLabel.textAlignment = .center
        tempLabel.textColor = .label

        iconImageView.contentMode = .scaleAspectFit

        let stack = UIStackView(arrangedSubviews: [timeLabel, iconImageView, tempLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            iconImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    func configure(with viewModel: HourlyItemViewModel) {
        timeLabel.text = viewModel.timeText
        tempLabel.text = viewModel.temperatureText
    }
}
