//
//  AnimalImageTableViewCell.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit
import Kingfisher

protocol AnimalImageTableViewCellDelegate: AnyObject {
    func didLikeTapped(isLike: Bool, at index: IndexPath)
}

class AnimalImageTableViewCell: UITableViewCell {

    private lazy var animalImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var favoriteImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.tintColor = .systemRed
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var favoriteBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundWithAlpha
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 23
        return view
    }()
    
    
    private lazy var nameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var nameBackgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .backgroundWithAlpha
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    weak var delegate: AnimalImageTableViewCellDelegate?
    private var isLike: Bool = false
    private var indexPath: IndexPath?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetView()
    }

    private func setupView() {
        selectionStyle = .none
        
        contentView.addSubview(animalImageView)
        contentView.addSubview(favoriteBackgroundView)
        contentView.addSubview(nameBackgroundView)
        favoriteBackgroundView.addSubview(favoriteImageView)
        nameBackgroundView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            animalImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            animalImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            animalImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            animalImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            favoriteBackgroundView.topAnchor.constraint(equalTo: animalImageView.topAnchor, constant: 10),
            favoriteBackgroundView.trailingAnchor.constraint(equalTo: animalImageView.trailingAnchor, constant: -10),
            favoriteBackgroundView.widthAnchor.constraint(equalToConstant: 46),
            favoriteBackgroundView.heightAnchor.constraint(equalToConstant: 46),
            
            favoriteImageView.widthAnchor.constraint(equalToConstant: 30),
            favoriteImageView.heightAnchor.constraint(equalToConstant: 30),
            favoriteImageView.centerXAnchor.constraint(equalTo: favoriteBackgroundView.centerXAnchor),
            favoriteImageView.centerYAnchor.constraint(equalTo: favoriteBackgroundView.centerYAnchor),
            
            nameBackgroundView.leadingAnchor.constraint(equalTo: animalImageView.leadingAnchor, constant: 10),
            nameBackgroundView.trailingAnchor.constraint(equalTo: animalImageView.trailingAnchor, constant: -10),
            nameBackgroundView.bottomAnchor.constraint(equalTo: animalImageView.bottomAnchor, constant: -12),
            nameBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.leadingAnchor.constraint(equalTo: nameBackgroundView.leadingAnchor, constant: 10),
            nameLabel.trailingAnchor.constraint(equalTo: nameBackgroundView.trailingAnchor, constant: -10),
            nameLabel.bottomAnchor.constraint(equalTo: nameBackgroundView.bottomAnchor, constant: -12),
            nameLabel.topAnchor.constraint(equalTo: nameBackgroundView.topAnchor, constant: 12)
        ])
        
        favoriteBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(likeTapped)))
    }
    
    private func resetView() {
        animalImageView.kf.cancelDownloadTask()
        animalImageView.image = nil
        favoriteImageView.image = nil
        nameLabel.text = nil
    }
    
    func setupContent(name: String, urlImage: String, isLike: Bool, at index: IndexPath, isFavoritePage: Bool) {
        let imageLike = isLike ? "star.fill" : "star"
        favoriteImageView.image = UIImage(systemName: imageLike)
        self.isLike = isLike
        self.indexPath = index
        
        let options = KingfisherOptionsInfo.defaultOptions
        let imageUrl = URL(string: urlImage)
        animalImageView.kf.setImage(with: imageUrl, options: options) { [weak self] result in
            guard let self else { return }
            switch result{
            case .success(let image):
                self.animalImageView.image = image.image
            case .failure:
                self.animalImageView.image = UIImage.defaultImage
            }
        }
        nameLabel.text = name
        nameBackgroundView.isHidden = !isFavoritePage
    }
    
    @objc func likeTapped() {
        guard let delegate, let indexPath else { return }
        isLike = !isLike
        delegate.didLikeTapped(isLike: isLike, at: indexPath)
    }
}

