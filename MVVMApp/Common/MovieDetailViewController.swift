//
//  MovieDetailViewController.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 23/04/2022.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MovieDetailViewController: BaseViewController {
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(AppIcon.image(icon: .back), for: .normal)
        return button
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = AppSize.Radius.medium.rawValue
        return image
    }()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xFFFFFF)
        view.layer.shadowColor = UIColor(rgb: 0x000000).cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.layer.masksToBounds = false
        view.layer.cornerRadius = AppSize.Radius.medium.rawValue
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.numberOfLines = 2
        label.font = AppFont.getFont(fontName: .openSans_SemiBold, size: 22)
        return label
    }()
    
    private lazy var dateImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = AppIcon.image(icon: .date)
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x727272)
        label.font = AppFont.getFont(fontName: .openSans_Regular, size: 14)
        return label
    }()
    
    private lazy var runtimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(rgb: 0x727272)
        label.font = AppFont.getFont(fontName: .openSans_Bold, size: 13)
        return label
    }()
    
    private var disposeBag: DisposeBag!
    private var viewModel: MovieDetailViewModelProtocol! {
        didSet {
            self.binding()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createComponents()
        self.setupConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor(rgb: 0xFFFFFF)
    }
}

extension MovieDetailViewController: BaseSetupView {
    func createComponents() {
        self.view.addSubview(self.backdropImageView)
        self.view.addSubview(self.shadowView)
        self.view.addSubview(self.posterImageView)
        self.view.addSubview(self.backButton)
        self.view.addSubview(self.nameLabel)
        self.view.addSubview(self.dateLabel)
        self.view.addSubview(self.runtimeLabel)
        self.view.addSubview(self.dateImageView)
    }
    
    func setupConstraints() {
        self.backdropImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(self.backdropImageView.snp.width).multipliedBy(9.0/16.0)
        }
        
        self.backButton.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.equalToSuperview().offset(AppSize.Spacing.inset.rawValue)
            make.width.height.equalTo(24)
        }

        self.posterImageView.snp.makeConstraints { make in
            make.top.equalTo(self.backdropImageView.snp.bottom).inset(42)
            make.leading.equalToSuperview().offset(AppSize.Spacing.inset.rawValue)
            make.width.equalTo(119)
            make.height.equalTo(self.posterImageView.snp.width).multipliedBy(3.0/2.0)
        }

        self.shadowView.snp.makeConstraints { make in
            make.edges.equalTo(self.posterImageView.snp.edges).inset(1)
        }

        self.nameLabel.snp.makeConstraints { make in
            make.top.equalTo(self.backdropImageView.snp.bottom).offset(20)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.greaterThanOrEqualTo(30)
        }

        self.dateImageView.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel.snp.bottom).offset(6)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(16)
            make.width.height.equalTo(20)
        }

        self.dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.dateImageView.snp.centerY)
            make.leading.equalTo(self.dateImageView.snp.trailing).offset(5)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(21)
        }

        self.runtimeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.dateLabel.snp.bottom).offset(6)
            make.leading.equalTo(self.posterImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(17)
        }
    }
    
    func binding() {
        self.viewModel.backdrop.bind(to: self.backdropImageView.rx.image).disposed(by: self.disposeBag)
        self.viewModel.poster.bind(to: self.posterImageView.rx.image).disposed(by: self.disposeBag)
        self.viewModel.name.bind(to: self.nameLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.date.bind(to: self.dateLabel.rx.text).disposed(by: self.disposeBag)
        self.viewModel.runtime.bind(to: self.runtimeLabel.rx.text).disposed(by: self.disposeBag)
        self.backButton.rx.action = self.viewModel.backAction
    }
    
    func setDisposeBag(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    func setViewModel(_ viewModel: MovieDetailViewModelProtocol) {
        self.viewModel = viewModel
    }
}
