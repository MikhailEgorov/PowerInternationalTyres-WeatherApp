//
//  WeatherViewController.swift
//  PowerInternationalTyres-WeatherApp
//
//  Created by Mikhail Egorov on 21.02.2026.
//
import UIKit

// MARK: - ViewState
enum WeatherViewState {
    case loading
    case content(WeatherViewModel)
    case error(String)
}

// MARK: - Sections
private enum Section: Int, CaseIterable {
    case current
    case hourly
    case forecast
}

// MARK: - ItemIdentifier
private struct Item: Sendable {
    let id: UUID
    let section: Section
}

nonisolated extension Item: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(section)
    }

    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs.id == rhs.id && lhs.section == rhs.section
    }
}

// MARK: - WeatherViewController
final class WeatherViewController: UIViewController, WeatherViewProtocol {

    var presenter: WeatherPresenterProtocol!
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private let refreshControl = UIRefreshControl()
    
    private let loadingView = UIView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    private let errorView = UIView()
    private let errorLabel = UILabel()
    private let retryButton = UIButton(type: .system)
    
    private var currentVM: CurrentSectionViewModel?
    private var hourlyVMs: [UUID: HourlyItemViewModel] = [:]
    private var forecastVMs: [UUID: ForecastItemViewModel] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureCollectionView()
        configureLoading()
        configureDataSource()
        configureRefresh()
        configureErrorView()
        
        presenter.viewDidLoad()
    }

    // MARK: - Render
    func render(state: WeatherViewState) {
        switch state {

        case .loading:
            loadingView.isHidden = false
            errorView.isHidden = true
            activityIndicator.startAnimating()

        case .content(let viewModel):
            loadingView.isHidden = true
            errorView.isHidden = true
            activityIndicator.stopAnimating()
            applySnapshot(viewModel)

        case .error(let message):
            loadingView.isHidden = true
            activityIndicator.stopAnimating()

            errorLabel.text = message
            errorView.isHidden = false
        }
    }
    
    // MARK: - configureError
    
    private func configureErrorView() {

        errorView.translatesAutoresizingMaskIntoConstraints = false
        errorView.backgroundColor = .systemBackground
        errorView.isHidden = true

        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.font = .systemFont(ofSize: 16)
        errorLabel.textColor = .label

        retryButton.translatesAutoresizingMaskIntoConstraints = false
        retryButton.setTitle("Повторить", for: .normal)
        retryButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [errorLabel, retryButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        errorView.addSubview(stack)
        view.addSubview(errorView)

        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: view.topAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            stack.centerXAnchor.constraint(equalTo: errorView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: errorView.centerYAnchor),
            stack.leadingAnchor.constraint(greaterThanOrEqualTo: errorView.leadingAnchor, constant: 32),
            stack.trailingAnchor.constraint(lessThanOrEqualTo: errorView.trailingAnchor, constant: -32)
        ])
    }
    
    @objc private func didTapRetry() {
        errorView.isHidden = true
        presenter.didPullToRefresh()
    }
    
    // MARK: - Loading
    
    private func configureLoading() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.backgroundColor = .systemBackground

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        loadingView.addSubview(activityIndicator)
        view.addSubview(loadingView)

        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
    }

    // MARK: - Refresh
    private func configureRefresh() {
        refreshControl.addTarget(self, action: #selector(didPull), for: .valueChanged)
    }

    @objc private func didPull() {
        presenter.didPullToRefresh()
    }

    // MARK: - Error
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default))
        present(alert, animated: true)
    }

    // MARK: - CollectionView Layouts
    private static func currentSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .estimated(150))
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        return section
    }

    private static func hourlySectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .absolute(80), heightDimension: .estimated(120))
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .estimated(80), heightDimension: .estimated(120)),
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 8
        return section
    }

    private static func forecastSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60))
        )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: item.layoutSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 0, leading: 16, bottom: 16, trailing: 16)
        section.interGroupSpacing = 8
        return section
    }

    // MARK: - Snapshot
    private func applySnapshot(_ viewModel: WeatherViewModel) {
        // Сохраняем view модели
        currentVM = viewModel.current
        hourlyVMs = Dictionary(uniqueKeysWithValues: viewModel.hourly.map { (UUID(), $0) })
        forecastVMs = Dictionary(uniqueKeysWithValues: viewModel.forecast.map { (UUID(), $0) })

        // Создаем snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(Section.allCases)

        if currentVM != nil {
            snapshot.appendItems([Item(id: UUID(), section: .current)], toSection: .current)
        }
        snapshot.appendItems(hourlyVMs.map { Item(id: $0.key, section: .hourly) }, toSection: .hourly)
        snapshot.appendItems(forecastVMs.map { Item(id: $0.key, section: .forecast) }, toSection: .forecast)

        dataSource.apply(snapshot, animatingDifferences: true)
        title = viewModel.locationTitle
        refreshControl.endRefreshing()
    }

    // MARK: - DataSource
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView,
            cellProvider: { [weak self] collectionView, indexPath, item in
                guard let self else { return nil }

                switch item.section {
                case .current:
                    guard let vm = self.currentVM else { return nil }
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CurrentCell.reuseId, for: indexPath) as! CurrentCell
                    cell.configure(with: vm)
                    return cell

                case .hourly:
                    guard let vm = self.hourlyVMs[item.id] else { return nil }
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.reuseId, for: indexPath) as! HourlyCell
                    cell.configure(with: vm)
                    return cell

                case .forecast:
                    guard let vm = self.forecastVMs[item.id] else { return nil }
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCell.reuseId, for: indexPath) as! ForecastCell
                    cell.configure(with: vm)
                    return cell
                }
            }
        )
    }

    // MARK: - CollectionView
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        collectionView.refreshControl = refreshControl
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        collectionView.register(CurrentCell.self, forCellWithReuseIdentifier: CurrentCell.reuseId)
        collectionView.register(HourlyCell.self, forCellWithReuseIdentifier: HourlyCell.reuseId)
        collectionView.register(ForecastCell.self, forCellWithReuseIdentifier: ForecastCell.reuseId)
    }

    private func createLayout() -> UICollectionViewLayout {
        UICollectionViewCompositionalLayout { sectionIndex, _ in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .current: return Self.currentSectionLayout()
            case .hourly: return Self.hourlySectionLayout()
            case .forecast: return Self.forecastSectionLayout()
            }
        }
    }
}
