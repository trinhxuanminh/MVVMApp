//
//  ShowFavoriteCollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 20/04/2022.
//

import Foundation
import UIKit

class ShowFavoriteCollectionViewCell: UICollectionViewCell {
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = AppSize.Radius.medium.rawValue
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.getFont(fontName: .openSans_Bold, size: 18)
        label.numberOfLines = 2
        label.textColor = UIColor(rgb: 0xFFFFFF)
        let myString = "Archive of your favorite movies"
        let myMutableString = NSMutableAttributedString(string: myString)
        myMutableString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(rgb: 0xEFFF56)], range: NSRange(location: 16, length: 8))
        label.attributedText = myMutableString
        return label
    }()
    
    private lazy var viewMoreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("View More", for: .normal)
        button.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        button.backgroundColor = UIColor(rgb: 0xFA7001)
        button.titleLabel?.font = AppFont.getFont(fontName: .openSans_SemiBold, size: 14)
        button.layer.cornerRadius = AppSize.Radius.medium.rawValue
        return button
    }()
    
    private lazy var illustrationImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = AppIcon.image(icon: .illustration)
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    
    private var viewModel: ShowFavoriteViewModelProtocol! {
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
    
    override func draw(_ rect: CGRect) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.gradientView.bounds
        gradientLayer.colors = [UIColor(rgb: 0xFDA503).cgColor, UIColor(rgb: 0xFB7102).cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.gradientView.layer.insertSublayer(gradientLayer, below: self.titleLabel.layer)
    }
}

extension ShowFavoriteCollectionViewCell: BaseSetupView {
    func createComponents() {
        self.contentView.addSubview(self.gradientView)
        self.gradientView.addSubview(self.titleLabel)
        self.gradientView.addSubview(self.viewMoreButton)
        self.contentView.addSubview(self.illustrationImageView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            self.gradientView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 12),
            self.gradientView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            self.gradientView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            self.gradientView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -32)
        ])
        
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.gradientView.topAnchor, constant: 16),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.gradientView.leadingAnchor, constant: 16),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.illustrationImageView.leadingAnchor, constant: -6),
            self.titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            self.viewMoreButton.heightAnchor.constraint(equalToConstant: 32),
            self.viewMoreButton.leadingAnchor.constraint(equalTo: self.gradientView.leadingAnchor, constant: 16),
            self.viewMoreButton.widthAnchor.constraint(equalToConstant: 102),
            self.viewMoreButton.bottomAnchor.constraint(equalTo: self.gradientView.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            self.illustrationImageView.heightAnchor.constraint(equalToConstant: 119),
            self.illustrationImageView.trailingAnchor.constraint(equalTo: self.gradientView.trailingAnchor, constant: -16),
            self.illustrationImageView.widthAnchor.constraint(equalToConstant: 153),
            self.illustrationImageView.bottomAnchor.constraint(equalTo: self.gradientView.bottomAnchor, constant: -16)
        ])
    }
    
    func binding() {
        self.viewMoreButton.rx.action = self.viewModel.viewMoreAction
    }
    
    func setViewModel(_ viewModel: ShowFavoriteViewModelProtocol) {
        self.viewModel = viewModel
    }
}
