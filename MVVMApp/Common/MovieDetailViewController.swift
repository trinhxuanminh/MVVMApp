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

class MovieDetailViewController: BaseViewController {
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(AppIcon.image(icon: .back), for: .normal)
        return button
    }()
    
    private lazy var backdropImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var posterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = AppSize.Radius.medium.rawValue
        return image
    }()
    
    private lazy var shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x1F1F1F)
        label.numberOfLines = 2
        label.font = AppFont.getFont(fontName: .openSans_SemiBold, size: 22)
        return label
    }()
    
    private lazy var dateImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = AppIcon.image(icon: .date)
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(rgb: 0x727272)
        label.font = AppFont.getFont(fontName: .openSans_Regular, size: 14)
        return label
    }()
    
    private lazy var runtimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
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
        NSLayoutConstraint.activate([
            self.backdropImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.backdropImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.backdropImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.backdropImageView.heightAnchor.constraint(equalTo: self.backdropImageView.widthAnchor, multiplier: 9/16)
        ])
        
        NSLayoutConstraint.activate([
            self.backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: AppSize.Spacing.inset.rawValue),
            self.backButton.widthAnchor.constraint(equalToConstant: 24),
            self.backButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            self.posterImageView.topAnchor.constraint(equalTo: self.backdropImageView.bottomAnchor, constant: -42),
            self.posterImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: AppSize.Spacing.inset.rawValue),
            self.posterImageView.widthAnchor.constraint(equalToConstant: 119),
            self.posterImageView.heightAnchor.constraint(equalTo: self.posterImageView.widthAnchor, multiplier: 3/2)
        ])
        
        NSLayoutConstraint.activate([
            self.shadowView.topAnchor.constraint(equalTo: self.posterImageView.topAnchor, constant: 1),
            self.shadowView.leadingAnchor.constraint(equalTo: self.posterImageView.leadingAnchor, constant: 1),
            self.shadowView.trailingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: -1),
            self.shadowView.bottomAnchor.constraint(equalTo: self.posterImageView.bottomAnchor, constant: -1)
        ])
        
        NSLayoutConstraint.activate([
            self.nameLabel.topAnchor.constraint(equalTo: self.backdropImageView.bottomAnchor, constant: 20),
            self.nameLabel.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 16),
            self.nameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            self.dateImageView.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 6),
            self.dateImageView.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 16),
            self.dateImageView.widthAnchor.constraint(equalToConstant: 20),
            self.dateImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            self.dateLabel.centerYAnchor.constraint(equalTo: self.dateImageView.centerYAnchor),
            self.dateLabel.leadingAnchor.constraint(equalTo: self.dateImageView.trailingAnchor, constant: 5),
            self.dateLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.dateLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
        
        NSLayoutConstraint.activate([
            self.runtimeLabel.topAnchor.constraint(equalTo: self.dateLabel.bottomAnchor, constant: 6),
            self.runtimeLabel.leadingAnchor.constraint(equalTo: self.posterImageView.trailingAnchor, constant: 16),
            self.runtimeLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.runtimeLabel.heightAnchor.constraint(equalToConstant: 17)
        ])
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
