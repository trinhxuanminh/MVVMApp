//
//  MoviePopularItemCollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 20/04/2022.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MoviePopularItemCollectionViewCell: UICollectionViewCell {
    
    lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = AppSize.Radius.medium.rawValue
        image.clipsToBounds = true
        return image
    }()
    
    lazy var setFavoriteButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.font = AppFont.getFont(fontName: .openSans_SemiBold, size: 15)
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x727272)
        label.font = AppFont.getFont(fontName: .openSans_Regular, size: 13)
        return label
    }()
    
    lazy var starImageView: UIImageView = {
        let image = UIImageView()
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
        self.posterImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.nameLabel.snp.top).offset(-8)
        }
        
        self.setFavoriteButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.leading.equalTo(self.posterImageView).offset(5)
        }
        
        self.nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(17)
            make.bottom.equalTo(self.dateLabel.snp.top).offset(-5)
        }
        
        self.dateLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(17)
        }
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
