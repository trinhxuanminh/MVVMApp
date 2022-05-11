//
//  MoviePopularItemCollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 20/04/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MoviePopularItemCollectionViewCell: UICollectionViewCell {
    
    lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = AppSize.Radius.medium.rawValue
        image.clipsToBounds = true
        return image
    }()
    
    lazy var setFavoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.font = AppFont.getFont(fontName: .openSans_SemiBold, size: 15)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x727272)
        label.font = AppFont.getFont(fontName: .openSans_Regular, size: 13)
        return label
    }()
    
    lazy var starImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = AppIcon.image(icon: .star)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private var viewModel: MovieViewModelProtocol! {
        didSet {
            self.binding()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createComponents()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MoviePopularItemCollectionViewCell: BaseSetupView {
    func createComponents() {
        self.contentView.addSubview(self.posterImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.dateLabel)
        self.contentView.addSubview(self.setFavoriteButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.posterImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.nameLabel.topAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            self.setFavoriteButton.topAnchor.constraint(equalTo: self.posterImageView.topAnchor, constant: 5),
            self.setFavoriteButton.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor, constant: 5),
            self.setFavoriteButton.heightAnchor.constraint(equalToConstant: 32),
            self.setFavoriteButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            self.nameLabel.heightAnchor.constraint(equalToConstant: 17),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.nameLabel.bottomAnchor.constraint(equalTo: self.dateLabel.topAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            self.dateLabel.heightAnchor.constraint(equalToConstant: 17),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.dateLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }
    
    func binding() {
        self.viewModel.poster.bind(to: self.posterImageView.rx.image).disposed(by: self.viewModel.disposeBag)
        self.viewModel.name.bind(to: self.nameLabel.rx.text).disposed(by: self.viewModel.disposeBag)
        self.viewModel.date.bind(to: self.dateLabel.rx.text).disposed(by: self.viewModel.disposeBag)
        self.setFavoriteButton.rx.action = self.viewModel.setFavoriteAction
        self.viewModel.favoriteState.bind(to: self.setFavoriteButton.rx.image()).disposed(by: self.viewModel.disposeBag)
    }
    
    func setViewModel(_ viewModel: MovieViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    func getViewModel() -> MovieViewModelProtocol {
        return self.viewModel
    }
}
