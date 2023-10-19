//
//  AnimalListViewController.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit

protocol IAnimalListViewController: AnyObject {
    func displayAnimalList(animals: [Animal])
    func displayError(log: String)
}

class AnimalListViewController: UIViewController {
    
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
    
    private let interactor: IAnimalListInteractor
    private let router: IAnimalListRouter
    
    private var idCell: String = "animalListIdCell"
    private var animals: [Animal] = []
    
    init() {
        let presenter = AnimalListPresenter()
        let worker = AnimalWorker(animalService: AnimalService.shared)
        interactor = AnimalListInteractor(presenter: presenter, worker: worker)
        router = AnimalListRouter()
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationView()
        setupContent()
    }
    
    private func setupView() {
        title = "Animals"
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AnimalListTableViewCell.self, forCellReuseIdentifier: idCell)
        
        activityIndicator.center = view.center
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setupNavigationView() {
        navigationController?.navigationBar.barTintColor = .white
    }
    
    private func setupContent() {
        activityIndicatorRunning()
        interactor.getAnimalList()
    }
    
    private func reloadAnimalList() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
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

extension AnimalListViewController: IAnimalListViewController {
    func displayAnimalList(animals: [Animal]) {
        self.animals = animals
        activityIndicatorStop()
        reloadAnimalList()
    }
    
    func displayError(log: String) {
        activityIndicatorStop()
        let alertController = UIAlertController(title: "Error", message: "log", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension AnimalListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return animals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idCell, for: indexPath) as? AnimalListTableViewCell,
              let animal = animals[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.setupContent(animal: animal)
        return cell
    }
}

extension AnimalListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let animal = animals[safe: indexPath.row] else { return }
        router.navigateToPokemonDetail(from: self, animal: animal)
    }
}
