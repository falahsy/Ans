//
//  AnimalListTableViewCell.swift
//  Ans
//
//  Created by Syamsul Falah on 18/10/23.
//

import UIKit

class AnimalListTableViewCell: UITableViewCell {

    private let animalNameLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .subheadline)
        view.numberOfLines = 2
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        animalNameLabel.text = nil
    }
    
    private func setupView() {
        selectionStyle = .none
        contentView.addSubview(animalNameLabel)
        NSLayoutConstraint.activate([
            animalNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            animalNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            animalNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            animalNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    func setupContent(animal: Animal) {
        animalNameLabel.text = animal.name
    }
}
