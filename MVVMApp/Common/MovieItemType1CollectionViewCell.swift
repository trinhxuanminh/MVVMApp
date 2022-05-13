//
//  MovieItemType1CollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 19/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MovieItemType1CollectionViewCell: UICollectionViewCell {
    
    enum Mode {
        case movieNowPlaying
        case favorite
    }
    
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = AppSize.Radius.medium.rawValue
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.numberOfLines = 2
        label.font = AppFont.getFont(fontName: .openSans_SemiBold, size: 15)
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x727272)
        label.font = AppFont.getFont(fontName: .openSans_Regular, size: 13)
        return label
    }()
    
    private lazy var starImageView: UIImageView = {
        let image = UIImageView()
        image.image = AppIcon.image(icon: .star)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private lazy var voteLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.font = AppFont.getFont(fontName: .openSans_Bold, size: 13)
        return label
    }()
    
    private lazy var deleteFavoriteButton: UIButton = {
        let button = UIButton()
        button.setImage(AppIcon.image(icon: .deleteFavorite), for: .normal)
        return button
    }()
    
    private lazy var setFavoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
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
        self.posterImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().offset(AppSize.Spacing.inset.rawValue)
            make.width.equalTo(self.posterImageView.snp.height).multipliedBy(2.0/3.0)
        }
        
        self.setFavoriteButton.snp.makeConstraints { make in
            make.top.leading.equalTo(self.posterImageView).offset(5)
            make.height.width.equalTo(32)
        }
        
        self.shadowView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.posterImageView).inset(20)
            make.leading.equalTo(self.posterImageView)
            make.trailing.equalToSuperview().inset(AppSize.Spacing.inset.rawValue)
        }
        
        self.deleteFavoriteButton.snp.makeConstraints { make in
            make.height.width.equalTo(32)
            make.top.trailing.equalTo(self.shadowView).inset(10)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.shadowView).offset(10)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(16)
            make.height.equalTo(42)
            make.trailing.equalTo(self.deleteFavoriteButton.snp.leading).offset(-16)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(16)
            make.height.equalTo(17)
            make.trailing.equalTo(self.shadowView.snp.trailing).inset(16)
        }
        
        self.starImageView.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(7)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(16)
            make.height.equalTo(16)
            make.width.equalTo(17)
        }
        
        self.voteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.starImageView)
            make.leading.equalTo(self.starImageView.snp.trailing).offset(7)
            make.height.equalTo(17)
            make.trailing.equalTo(self.shadowView).inset(16)
        }
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

