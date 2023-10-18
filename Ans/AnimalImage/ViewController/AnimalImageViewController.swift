//
//  AnimalImagesViewController.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit

protocol IAnimalImagesViewController: AnyObject {
    func displayImages(images: [Photo])
    func displayError(log: String)
}

class AnimalImagesViewController: UIViewController {
    
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
    
    private let interactor: IAnimalImagesInteractor
    private var animalName: String
    
    private let idImageCell: String = "imageCell"
    private var photos: [Photo] = []
    
    init(animalName: String) {
        self.animalName = animalName
        let presenter = AnimalImagesPresenter()
        let worker = ImageWorker(imageService: ImageService.shared)
        interactor = AnimalImagesInteractor(presenter: presenter, worker: worker)
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = animalName.capitalized
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        title = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupNavigation()
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
    
    private func setupContent() {
        activityIndicatorRunning()
        interactor.getImages(query: animalName)
    }

    private func reloadAnimalImage() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadData()
        }
    }
    
    private func reloadAnimeImageRow(at index: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.tableView.reloadRows(at: [index], with: .automatic)
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

extension AnimalImagesViewController: IAnimalImagesViewController {
    func displayImages(images: [Photo]) {
        photos = images
        activityIndicatorStop()
        reloadAnimalImage()
    }
    
    func displayError(log: String) {
        activityIndicatorStop()
        let alertController = UIAlertController(title: "Error", message: "log", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
}

extension AnimalImagesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idImageCell, for: indexPath) as? AnimalImageTableViewCell,
              let photo = photos[safe: indexPath.row] else {
            return UITableViewCell()
        }
        let isLike = indexPath.row % 2 == 0
        cell.setupContent(image: photo, isLike: isLike, at: indexPath)
        cell.delegate = self
        return cell
    }
}

extension AnimalImagesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height/4
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row == photos.count - 3, interactor.hasNext else { return }
        setupContent()
    }
}

extension AnimalImagesViewController: AnimalImageTableViewCellDelegate {
    func didLikeTapped(isLike: Bool, at index: IndexPath) {
        reloadAnimeImageRow(at: index)
    }
}
