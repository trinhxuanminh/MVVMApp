//
//  ShowFavoriteCollectionViewCell.swift
//  MVVMApp
//
//  Created by Trịnh Xuân Minh on 20/04/2022.
//

import Foundation
import UIKit
import SnapKit

class ShowFavoriteCollectionViewCell: UICollectionViewCell {
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = AppSize.Radius.medium.rawValue
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
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
        button.setTitle("View More", for: .normal)
        button.setTitleColor(UIColor(rgb: 0xFFFFFF), for: .normal)
        button.backgroundColor = UIColor(rgb: 0xFA7001)
        button.titleLabel?.font = AppFont.getFont(fontName: .openSans_SemiBold, size: 14)
        button.layer.cornerRadius = AppSize.Radius.medium.rawValue
        return button
    }()
    
    private lazy var illustrationImageView: UIImageView = {
        let image = UIImageView()
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
        self.gradientView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().inset(32)
        }
        
        self.titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.gradientView).offset(16)
            make.trailing.equalTo(self.illustrationImageView.snp.leading).inset(6)
            make.height.equalTo(50)
        }
        
        self.viewMoreButton.snp.makeConstraints { make in
            make.leading.bottom.equalTo(self.gradientView).inset(16)
            make.height.equalTo(32)
            make.width.equalTo(102)
        }
        
        self.illustrationImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalTo(self.gradientView).inset(16)
            make.height.equalTo(119)
            make.width.equalTo(153)
        }
    }
    
    func binding() {
        self.viewMoreButton.rx.action = self.viewModel.viewMoreAction
    }
    
    func setViewModel(_ viewModel: ShowFavoriteViewModelProtocol) {
        self.viewModel = viewModel
    }
}
