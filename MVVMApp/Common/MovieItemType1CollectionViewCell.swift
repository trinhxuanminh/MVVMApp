//
//  MovieItemType1CollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import UIKit
import RxSwift
import RxCocoa

class MovieItemType1CollectionViewCell: UICollectionViewCell {
    
    enum Mode {
        case movieNowPlaying
        case favorite
    }
    
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = AppSize.Radius.medium.rawValue
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.numberOfLines = 2
        label.font = AppFont.getFont(fontName: .openSans_SemiBold, size: 15)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x727272)
        label.font = AppFont.getFont(fontName: .openSans_Regular, size: 13)
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = AppIcon.image(icon: .star)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var voteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.font = AppFont.getFont(fontName: .openSans_Bold, size: 13)
        return label
    }()
    
    private lazy var deleteFavoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(AppIcon.image(icon: .deleteFavorite), for: .normal)
        return button
    }()
    
    private lazy var setFavoriteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)
        view.layer.shadowColor = UIColor(rgb: 0x000000).cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        view.layer.cornerRadius = AppSize.Radius.medium.rawValue
        return view
    }()
    
    private var viewModel: MovieViewModelProtocol! {
        didSet {
            self.binding()
        }
    }
    private var deleteButtonDisposable: Disposable?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createComponents()
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.deleteButtonDisposable?.dispose()
    }
}

extension MovieItemType1CollectionViewCell: BaseSetupView {
    func createComponents() {
        self.contentView.addSubview(self.shadowView)
        self.contentView.addSubview(self.posterImageView)
        self.shadowView.addSubview(self.nameLabel)
        self.shadowView.addSubview(self.dateLabel)
        self.shadowView.addSubview(self.starImageView)
        self.shadowView.addSubview(self.voteLabel)
        self.shadowView.addSubview(self.deleteFavoriteButton)
        self.contentView.addSubview(self.setFavoriteButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.posterImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: AppSize.Spacing.inset.rawValue),
            self.posterImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            self.posterImageView.widthAnchor.constraint(equalTo: self.posterImageView.heightAnchor, multiplier: 2/3)
        ])
        
        NSLayoutConstraint.activate([
            self.setFavoriteButton.topAnchor.constraint(equalTo: self.posterImageView.topAnchor, constant: 5),
            self.setFavoriteButton.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor, constant: 5),
            self.setFavoriteButton.heightAnchor.constraint(equalToConstant: 32),
            self.setFavoriteButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            self.shadowView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor, constant: 20),
            self.shadowView.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor),
            self.shadowView.bottomAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: -20),
            self.shadowView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -AppSize.Spacing.inset.rawValue)
        ])
        
        NSLayoutConstraint.activate([
            self.deleteFavoriteButton.topAnchor.constraint(equalTo: self.shadowView.topAnchor, constant: 10),
            self.deleteFavoriteButton.trailingAnchor.constraint(equalTo: self.shadowView.trailingAnchor, constant: -10),
            self.deleteFavoriteButton.heightAnchor.constraint(equalToConstant: 32),
            self.deleteFavoriteButton.widthAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.shadowView.topAnchor, constant: 10),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 16),
            self.nameLabel.heightAnchor.constraint(equalToConstant: 42),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.deleteFavoriteButton.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            self.dateLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 5),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 16),
            self.dateLabel.heightAnchor.constraint(equalToConstant: 17),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.shadowView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            self.starImageView.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 7),
            self.starImageView.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 16),
            self.starImageView.heightAnchor.constraint(equalToConstant: 16),
            self.starImageView.widthAnchor.constraint(equalToConstant: 17)
        ])
        
        NSLayoutConstraint.activate([
            self.voteLabel.centerYAnchor.constraint(equalTo: self.starImageView.centerYAnchor),
            self.voteLabel.leadingAnchor.constraint(equalTo: self.starImageView.trailingAnchor, constant: 7),
            self.voteLabel.heightAnchor.constraint(equalToConstant: 17),
            self.voteLabel.trailingAnchor.constraint(equalTo: self.shadowView.trailingAnchor, constant: -16)
        ])
    }
    
    func binding() {
        self.viewModel.poster.bind(to: self.posterImageView.rx.image).disposed(by: self.viewModel.disposeBag)
        self.viewModel.name.bind(to: self.nameLabel.rx.text).disposed(by: self.viewModel.disposeBag)
        self.viewModel.date.bind(to: self.dateLabel.rx.text).disposed(by: self.viewModel.disposeBag)
        self.viewModel.vote.bind(to: self.voteLabel.rx.text).disposed(by: self.viewModel.disposeBag)
        self.deleteFavoriteButton.rx.action = self.viewModel.deleteFavoriteAction
        self.setFavoriteButton.rx.action = self.viewModel.setFavoriteAction
        self.viewModel.favoriteState.bind(to: self.setFavoriteButton.rx.image()).disposed(by: self.viewModel.disposeBag)
    }
    
    func setViewModel(_ viewModel: MovieViewModelProtocol) {
        self.viewModel = viewModel
    }
    
    func getViewModel() -> MovieViewModelProtocol {
        return self.viewModel
    }
    
    func setupUI(mode: Mode) {
        switch mode {
        case .movieNowPlaying:
            self.deleteFavoriteButton.isHidden = true
        case .favorite:
            self.setFavoriteButton.isHidden = true
        }
    }
    
    func setDeleteButtonDisposable(onNext: (() -> Void)? = nil) {
        self.deleteButtonDisposable = self.deleteFavoriteButton.rx.tap.subscribe(onNext: { _ in
            onNext?()
        })
    }
}

