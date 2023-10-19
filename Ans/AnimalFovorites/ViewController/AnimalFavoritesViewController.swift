//
//  AnimalFavoritesViewController.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit

protocol IAnimalFavoritesViewController: AnyObject {
    func displayAnimalFavorites(animals: [AnimalFavorite])
    func displaytError(log: String)
}

class AnimalFavoritesViewController: UIViewController {

    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.estimatedRowHeight = UITableView.automaticDimension
        return view
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.hidesWhenStopped = true
        activityView.style = .medium
        activityView.color = .black
        return activityView
    }()
    
    private let interactor: IAnimalFavoritesInteractor
    
    private let idImageCell: String = "imageCell"
    private var animals: [AnimalFavorite] = []
    
    private var familySelected: String = "All"
    
    init() {
        let presenter = AnimalFavoritesPresenter()
        interactor = AnimalFavoritesInteractor(presenter: presenter)
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigation()
        setupFilterViews()
        setupContent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupContent()
    }

    private func setupView() {
        view.backgroundColor  = .white
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AnimalImageTableViewCell.self, forCellReuseIdentifier: idImageCell)
        
        activityIndicator.center = view.center
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigation() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupFilterViews() {
        title = familySelected == "All" ? "Favorites Animal" : "\(familySelected)"
        
        let filterMenu = generateFilterMenu()
        let categoryBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
            primaryAction: nil,
            menu: UIMenu(title: "", children: filterMenu)
        )
        categoryBarButtonItem.tintColor = .gray
        navigationItem.rightBarButtonItems = [categoryBarButtonItem]
    }
    
    private func generateFilterMenu() -> [UIAction] {
        var filterMenu = SpeciesAnimal.listAnimal
        filterMenu.insert("All", at: 0)
        let menus = filterMenu.map { animal in
            let state: UIMenuElement.State = familySelected == animal ? .on : .off
            return UIAction(title: animal, image: nil, state: state) { [weak self] action in
                self?.appliedFilter(family: animal)
            }
        }
        return menus
    }
    
    private func appliedFilter(family: String) {
        familySelected = family
        interactor.selectedFamily(family: family)
        setupContent()
        setupFilterViews()
    }
    
    private func setupContent() {
        activityIndicatorRunning()
        interactor.getFavoritesAnimal()
    }
    
    private func reloadAnimalFavorites() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func reloadAnimeImageRow(at index: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadRows(at: [index], with: .none)
        }
    }
    
    private func activityIndicatorRunning() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            activityIndicator.startAnimating()
            view.isUserInteractionEnabled = false
        }
    }
    
    private func activityIndicatorStop() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
        }
    }
}

extension AnimalFavoritesViewController: IAnimalFavoritesViewController {
    func displayAnimalFavorites(animals: [AnimalFavorite]) {
        self.animals = animals
        activityIndicatorStop()
        reloadAnimalFavorites()
    }
    
    func displaytError(log: String) {
        activityIndicatorStop()
        let alertController = UIAlertController(title: "Error", message: "log", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension AnimalFavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idImageCell, for: indexPath) as? AnimalImageTableViewCell,
              let animal = animals[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.setupContent(name: animal.name, urlImage: animal.src, isLike: animal.liked, at: indexPath, isFavoritePage: true)
        cell.delegate = self
        return cell
    }
}

extension AnimalFavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/4
    }
}

extension AnimalFavoritesViewController: AnimalImageTableViewCellDelegate {
    func didLikeTapped(isLike: Bool, at index: IndexPath) {
        guard let animal = animals[safe: index.row] else { return }
        if isLike {
            let animalFavorite = AnimalFavorite(id: animal.id, name: animal.name, family: animal.family , liked: isLike, src: animal.src)
            interactor.saveImages(animalFavorite: animalFavorite)
        } else {
            interactor.deleteImages(id: animal.id)
        }
    }
}
